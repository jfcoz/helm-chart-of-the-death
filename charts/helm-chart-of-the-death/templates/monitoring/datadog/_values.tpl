{{/* values */}}
{{- define "monitoring.datadog.defaultValues" }}
{{- $me := .Values.components.monitoring.datadog }}

datadog:
  # reduce loglevel by default, else can cost a lot in stackdriver/loganalytics/cloudwatch/datadog logging…
  logLevel: ERROR

  site: "datadoghq.eu"
  clusterName: {{ .Values.general.clusterName | quote }}
  apiKey: {{ $me.config.apiKey }}

  kubelet:
    {{- if or
            (eq .Values.cloudProvider "scw")
    }}
    tlsVerify: false
    {{- else }}
    tlsVerify: true
    {{- end }}

  # Uncomment this only if needed, this will cost the log volume
  logs:
    enabled: false
    containerCollectAll: false

  networkPolicy:
    create: true

  # exclude gke event exporter : can be verbose when stackdriver is not enabled
  containerExcludeLogs: "image:gke.gcr.io/event-exporter"

  operator:
    enabled: false

  env:

  - name: DD_LOGS_CONFIG_TAGGER_WARMUP_DURATION
    # needed for short live cronjob with tags from namespaces
    # For DD_LOGS_CONFIG_TAGGER_WARMUP_DURATION please see our docs here: https://docs.datadoghq.com/containers/kubernetes/log/?tab=datadogoperator#missing-tags-on-new-containers-or-pods
    value: 60

  - name: DD_KUBERNETES_METADATA_TAG_UPDATE_FREQ
    # For DD_KUBERNETES_METADATA_TAG_UPDATE_FREQ you can refer to  https://github.com/DataDog/datadog-agent/blob/main/pkg/config/config_template.yaml#L3492-L3496
    value: 10

  - name: DD_TRACE_ENABLED
    # disable Tracing by default to reduce costs
    value: 0

  # we force communication via local service
  # else we need kyverno disable-host-path exclusion for any application Pod
  # for this we need to disable socket/enable port on dogstatsd and apm
  dogstatsd:
    useSocketVolume: false
    useHostPort: false

  apm:
    socketEnabled: false
    portEnabled: false
    useLocalService: true

  admissionController:
    configMode: service


agents:
  revisionHistoryLimit: 3
  priorityClassCreate: true
  priorityClassName: datadog

  tolerations:
  # match any taint
  - operator: "Exists"

  containers:
    agent:
      resources:
        requests:
          cpu: 100m
          memory: 256Mi

    processAgent:
      resources:
        requests:
          cpu: 10m
          memory: 64Mi

    traceAgent:
      resources:
        requests:
          cpu: 30m
          memory: 100Mi


  updateStrategy:
    rollingUpdate:
      maxUnavailable: "50%"

clusterAgent:
  revisionHistoryLimit: 3
  podAnnotations:
    cluster-autoscaler.kubernetes.io/safe-to-evict-local-volumes: datadogrun,varlog,tmpdir,config

{{- end }}

{{/* merged values : default + user  */}}
{{- define "monitoring.datadog.mergedValues" }}
{{- $me := .Values.components.monitoring.datadog }}
{{- $defaultValues := include "monitoring.datadog.defaultValues" . | fromYaml }}
{{- $customValues := $me.values | default dict }}
{{- /*
We need to use common.merge for a deep merge of datadog.env vars array, with higher priority for user value for each uniq name
*/}}
{{- include "common.merge" (list
$defaultValues
$customValues
(fromYaml "datadog:\n  env:\n    strategy: merge\n    mergeKey: name")
) }}
{{- end }}

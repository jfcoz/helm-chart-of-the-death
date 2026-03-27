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

agents:
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

  updateStrategy:
    rollingUpdate:
      maxUnavailable: "50%"

{{- end }}

{{/* merged values : default + user  */}}
{{- define "monitoring.datadog.mergedValues" }}
{{- $me := .Values.components.monitoring.datadog }}
{{- $defaultValues := include "monitoring.datadog.defaultValues" . | fromYaml }}
{{- $customValues := $me.values | default dict }}
{{- mergeOverwrite $defaultValues $customValues | toYaml }}
{{- end }}

{{/* values */}}
{{- define "monitoring.k8sMonitoring.defaultValues" }}
{{- $me := .Values.components.monitoring.k8sMonitoring }}

cluster:
  name: {{ .Values.global.clusterName | required "missing global.clusterName" | quote }}


# Features

clusterMetrics:
  # ClusterMetrics enable kube-state-metrics / node-exporter / kepler / opencost
  {{- if include "common.used" .Values.components.monitoring.kubePrometheusStack }}
  enabled: false
  {{- else }}
  enabled: true
  {{- end }}

clusterEvents:
  enabled: true

podLogs:
  enabled: true

nodeLogs:
  enabled: true



# Collectors

alloy-metrics:
  {{- if include "common.used" .Values.components.monitoring.kubePrometheusStack }}
  # kube-state-metrics is already managed, we prefer it due to custom resources collected (HelmRelease...)
  enabled: false
  {{- else }}
  enabled: true
  {{- end }}

alloy-singleton:
  # collect Kubernetes events
  enabled: true

  # https://github.com/grafana/k8s-monitoring-helm/blob/ea357b0204031a05adc478f4778875c6122b0a98/charts/k8s-monitoring/collectors/alloy-values.yaml
  # we remove useless capabilities
  alloy:
    securityContext:
      capabilities:
        add: []

alloy-logs:
  enabled: true

  # https://github.com/grafana/k8s-monitoring-helm/blob/ea357b0204031a05adc478f4778875c6122b0a98/charts/k8s-monitoring/collectors/alloy-values.yaml
  # we remove useless capabilities
  alloy:
    securityContext:
      capabilities:
        add: []


destinationsMap:
  # hostedMetrics:
  #   type: prometheus
  #   url: https://prometheus.example.com/api/prom/push
  #   auth:
  #     type: basic
  #     username: "my-username"
  #     password: "my-password"
  localPrometheus:
    type: prometheus
    url: {{ template "monitoring.kubePrometheusStack.prometheusWriteEndpoint" . }}
  # hostedLogs:
  #   type: loki
  #   url: https://loki.example.com/loki/api/v1/push
  #   auth:
  #     type: basic
  #     username: "my-username"
  #     password: "my-password"
  #     tenantIdFrom: env("LOKI_TENANT_ID")
  localLogs:
    type: loki
    url: {{ template "monitoring.loki.writeEndpoint" . }}/loki/api/v1/push
    #auth:
    #  type: basic
    #  username: "my-username"
    #  password: "my-password"
    #  tenantIdFrom: env("LOKI_TENANT_ID")

#  tolerations:
#  - key: master
#    operator: Exists
#    effect: NoSchedule
#  - key: storage
#    operator: Exists
#    effect: NoSchedule
#  updateStrategy:
#    rollingUpdate:
#      maxUnavailable: 50%


{{- if include "common.used" .Values.components.monitoring.kubePrometheusStack }}
serviceMonitor:
  enabled: true
{{- end }}

{{- end }}

{{/* merged values : default + user  */}}
{{- define "monitoring.k8sMonitoring.mergedValues" }}
{{- $me := .Values.components.monitoring.k8sMonitoring }}
{{- $defaultValues := include "monitoring.k8sMonitoring.defaultValues" . | fromYaml }}
{{- $customValues := $me.values | default dict }}
{{- mergeOverwrite $defaultValues $customValues | toYaml }}
{{- end }}

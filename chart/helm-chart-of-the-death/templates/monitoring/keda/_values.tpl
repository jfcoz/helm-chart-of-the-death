{{/* values */}}
{{- define "monitoring.keda.defaultValues" }}
# doc: https://github.com/kedacore/charts/tree/main/keda
prometheus:
  metricServer:
    enabled: true
    {{- if include "common.used" .Values.components.monitoring.kubePrometheusStack }}
    podMonitor:
      enabled: true
    serviceMonitor:
      enabled: true
    {{- end }}
  operator:
    enabled: true
    {{- if include "common.used" .Values.components.monitoring.kubePrometheusStack }}
    podMonitor:
      enabled: true
    serviceMonitor:
      enabled: true
    prometheusRules:
      enabled: true
    {{- end }}
  webhooks:
    enabled: true
    {{- if include "common.used" .Values.components.monitoring.kubePrometheusStack }}
    serviceMonitor:
      enabled: true
    prometheusRules:
      enabled: true
    {{- end }}
{{- end }}

{{/* merged values : default + user  */}}
{{- define "monitoring.keda.mergedValues" }}
{{- $me := .Values.components.monitoring.keda }}
{{- $defaultValues := include "monitoring.keda.defaultValues" . | fromYaml }}
{{- $customValues := $me.values | default dict }}
{{- mergeOverwrite $defaultValues $customValues | toYaml }}
{{- end }}

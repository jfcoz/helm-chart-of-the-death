{{/* values */}}
{{- define "security.externalSecrets.defaultValues" }}
{{- $me := .Values.components.security.externalSecrets }}
revisionHistoryLimit: {{ .Values.general.revisionHistoryLimit }}
resources:
  requests:
    cpu: 5m
    memory: 32M

certController:
  revisionHistoryLimit: {{ .Values.general.revisionHistoryLimit }}
  resources:
    requests:
      cpu: 5m
      memory: 32M

webhook:
  revisionHistoryLimit: {{ .Values.general.revisionHistoryLimit }}
  resources:
    requests:
      cpu: 5m
      memory: 32M

{{- if include "common.used" .Values.components.monitoring.kubePrometheusStack }}
serviceMonitor:
  enabled: true
grafanaDashboard:
  enabled: true
{{- end }}

log:
  level: warn
{{- end }}


{{/* merged values : default + user  */}}
{{- define "security.externalSecrets.mergedValues" }}
{{- $me := .Values.components.security.externalSecrets }}
{{- $defaultValues := include "security.externalSecrets.defaultValues" . | fromYaml }}
{{- $customValues := $me.values | default dict }}
{{- mergeOverwrite $defaultValues $customValues | toYaml }}
{{- end }}

{{/* values */}}
{{- define "gitops.argocdImageUpdater.defaultValues" }}
{{- $me := .Values.components.gitops.argocdImageUpdater }}

resources:
  requests:
    cpu: 2m
    memory: 20M
metrics:
  {{- if include "common.used" .Values.components.monitoring.kubePrometheusStack }}
  enabled: true
  serviceMonitor:
    enabled: true
  {{- else }}
  enabled: false
  {{- end }}

{{- end }}


{{/* merged values : default + user  */}}
{{- define "gitops.argocdImageUpdater.mergedValues" }}
{{- $me := .Values.components.gitops.argocdImageUpdater }}
{{- $defaultValues := include "gitops.argocdImageUpdater.defaultValues" . | fromYaml }}
{{- $customValues := $me.values | default dict }}
{{- mergeOverwrite $defaultValues $customValues | toYaml }}
{{- end }}

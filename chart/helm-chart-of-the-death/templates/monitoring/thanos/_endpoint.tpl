{{/* thanos endpoint */}}
{{- define "monitoring.thanos.endpoint" -}}
http://thanos-query.{{ .Values.components.monitoring.thanos.namespace }}:10902
{{- end }}

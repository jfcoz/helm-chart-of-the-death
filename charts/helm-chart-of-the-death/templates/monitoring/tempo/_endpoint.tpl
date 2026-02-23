{{/* tempo distributor endpoint */}}
{{- define "monitoring.tempo.distributorEndpoint" -}}
tempo-distributor.{{ .Values.components.monitoring.tempo.namespace}}:4317
{{- end }}

{{/* tempo query endpoint */}}
{{- define "monitoring.tempo.queryEndpoint" -}}
http://tempo-query-frontend.{{ .Values.components.monitoring.tempo.namespace}}:3200
{{- end }}

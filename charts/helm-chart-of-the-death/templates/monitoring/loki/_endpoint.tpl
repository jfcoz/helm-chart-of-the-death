{{/* loki read endpoint */}}
{{- define "monitoring.loki.readEndpoint" }}
{{- $me := .Values.components.monitoring.loki }}
{{- if eq $me.config.deploymentMode "SimpleScalable" -}}
http://loki-read.{{ $me.namespace}}:3100
{{- else if eq $me.config.deploymentMode "Distributed" -}}
http://loki-query-frontend.{{ $me.namespace}}:3100
{{- else if eq $me.config.deploymentMode "SingleBinary" -}}
http://loki.{{ $me.namespace}}:3100
{{- else }}
{{- fail "Unsupported monitoring.loki.config.deploymentMode" }}
{{- end }}
{{- end }}

{{/* loki write endpoint */}}
{{- define "monitoring.loki.writeEndpoint" -}}
{{- $me := .Values.components.monitoring.loki }}
{{- if eq $me.config.deploymentMode "SimpleScalable" -}}
http://loki-write.{{ $me.namespace}}:3100
{{- else if eq $me.config.deploymentMode "Distributed" -}}
http://loki-distributor.{{ $me.namespace}}:3100
{{- else if eq $me.config.deploymentMode "SingleBinary" -}}
http://loki.{{ $me.namespace}}:3100
{{- else }}
{{- fail "Unsupported monitoring.loki.config.deploymentMode" }}
{{- end }}
{{- end }}

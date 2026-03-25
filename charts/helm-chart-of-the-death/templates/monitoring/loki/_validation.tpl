{{/* Validate aws.endpoint syntax */}}
{{- $me := .Values.components.monitoring.loki }}
{{- if not regexMatch "^([a-z0-9-]+\\.)[a-z0-9-]+$" $me.config.aws.endpoint }}
{{ fail "invalid components.monitoring.loki.config.aws.endpoint. It must only contains hostname" }}
{{ end }}


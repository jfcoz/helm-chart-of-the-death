{{/* Validate aws.endpoint syntax */}}
{{- $me := .Values.components.backup.velero }}
{{- if not regexMatch "^([a-z0-9-]+\\.)[a-z0-9-]+$" $me.config.aws.endpoint }}
{{ fail "invalid components.backup.velero.config.aws.endpoint. It must only contains hostname" }}
{{ end }}


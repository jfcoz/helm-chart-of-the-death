{{/* Validate general.clusterName */}}
{{- if not regexMatch "^([a-z0-9-]+$" .Values.general.clusterName }}
{{ fail "invalid or missing general.clusterName" }}
{{ end }}


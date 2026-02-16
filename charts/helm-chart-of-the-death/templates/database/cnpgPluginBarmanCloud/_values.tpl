{{/* values */}}
{{- define "database.cnpgPluginBarmanCloud.defaultValues" }}
{{- $me := .Values.components.database.cnpgPluginBarmanCloud }}
# TODO
{{- end }}

{{/* merged values : default + user  */}}
{{- define "database.cnpgPluginBarmanCloud.mergedValues" }}
{{- $me := .Values.components.database.cnpgPluginBarmanCloud }}
{{- $defaultValues := include "database.cnpgPluginBarmanCloud.defaultValues" . | fromYaml }}
{{- $customValues := $me.values | default dict }}
{{- mergeOverwrite $defaultValues $customValues | toYaml }}
{{- end }}

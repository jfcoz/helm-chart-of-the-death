{{/* values */}}
{{- define "gitops.argocdImageUpdater.defaultValues" }}
{{- $me := .Values.components.gitops.argocdImageUpdater }}

# TODO

{{- end }}


{{/* merged values : default + user  */}}
{{- define "gitops.argocdImageUpdater.mergedValues" }}
{{- $me := .Values.components.gitops.argocdImageUpdater }}
{{- $defaultValues := include "gitops.argocdImageUpdater.defaultValues" . | fromYaml }}
{{- $customValues := $me.values | default dict }}
{{- mergeOverwrite $defaultValues $customValues | toYaml }}
{{- end }}

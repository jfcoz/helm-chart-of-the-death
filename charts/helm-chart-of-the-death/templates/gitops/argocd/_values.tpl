{{/* values */}}
{{- define "gitops.argocd.defaultValues" }}
{{- $me := .Values.components.gitops.argocd }}
# TODO
{{- end }}


{{/* merged values : default + user  */}}
{{- define "gitops.argocd.mergedValues" }}
{{- $me := .Values.components.gitops.argocd }}
{{- $defaultValues := include "gitops.argocd.defaultValues" . | fromYaml }}
{{- $customValues := $me.values | default dict }}
{{- mergeOverwrite $defaultValues $customValues | toYaml }}
{{- end }}

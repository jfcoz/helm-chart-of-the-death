{{/* argocd endpoint */}}
{{- define "gitops.argocd.domain" -}}
argocd.{{ .Values.general.ingressWildcardSuffix | required "missing general.ingressWildcardSuffix" }}
{{- end }}

{{/* argocd dex callback */}}
{{- define "gitops.argocd.dexCallback" -}}
https://{{ template "gitops.argocd.domain" . }}/dex/callback
{{- end }}

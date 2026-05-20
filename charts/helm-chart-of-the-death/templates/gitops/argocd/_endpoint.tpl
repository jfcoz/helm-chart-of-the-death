{{/* argocd endpoint */}}
{{- define "gitops.argocd.domain" -}}
argocd.{{ .Values.general.dnsWildcardSuffixes.ingress.nginx | required "missing general.ingressWildcardSuffix" }}
{{- end }}

{{/* argocd dex callback */}}
{{- define "gitops.argocd.dexCallback" -}}
https://{{ template "gitops.argocd.domain" . }}/api/dex/callback
{{- end }}

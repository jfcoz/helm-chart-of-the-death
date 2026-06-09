{{/* argocd endpoint */}}
{{- define "gitops.argocd.domain" -}}
{{- if (((.Values.general).dnsWildcardSuffixes).gateway).cilium -}}
argocd.{{ .Values.general.dnsWildcardSuffixes.gateway.cilium }}
{{- else if (((.Values.general).dnsWildcardSuffixes).ingress).nginx -}}
argocd.{{ .Values.general.dnsWildcardSuffixes.ingress.nginx }}
{{- else }}
{{- fail "at least one general.dnsWildcardSuffixes is missing for argocd" }}
{{- end }}
{{- end }}

{{/* argocd dex callback */}}
{{- define "gitops.argocd.dexCallback" -}}
https://{{ template "gitops.argocd.domain" . }}/api/dex/callback
{{- end }}

{{/* values */}}
{{- define "security.certManagerWebhookScaleway.defaultValues" }}
{{- $certManager := .Values.components.security.certManager }}
{{- $certManagerValues := $certManager.values | default dict }}
{{- /* same rules as cert-manager's serviceAccountName helper, release name cert-manager */}}
{{- $serviceAccountName := dig "serviceAccount" "name" "" $certManagerValues }}
{{- if not $serviceAccountName }}
{{- if dig "serviceAccount" "create" true $certManagerValues }}
{{- $serviceAccountName = $certManagerValues.fullnameOverride | default "cert-manager" }}
{{- else }}
{{- $serviceAccountName = "default" }}
{{- end }}
{{- end }}
# the APIService RBAC grants access to cert-manager's service account
certManager:
  namespace: {{ $certManager.namespace }}
  serviceAccountName: {{ $serviceAccountName }}
resources:
  requests:
    memory: 20Mi
    cpu: 1m
{{- end }}


{{/* merged values : default + user  */}}
{{- define "security.certManagerWebhookScaleway.mergedValues" }}
{{- $me := .Values.components.security.certManagerWebhookScaleway }}
{{- $defaultValues := include "security.certManagerWebhookScaleway.defaultValues" . | fromYaml }}
{{- $customValues := $me.values | default dict }}
{{- mergeOverwrite $defaultValues $customValues | toYaml }}
{{- end }}

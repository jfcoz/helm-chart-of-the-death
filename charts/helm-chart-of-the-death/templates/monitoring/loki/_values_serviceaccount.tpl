{{/* values for serviceAccount */}}
{{- define "monitoring.loki.serviceAccount" }}
{{- $me := .Values.components.monitoring.loki }}

{{- if eq .Values.cloudProvider "aws" }}
serviceAccount:
  annotations:
    eks.amazonaws.com/role-arn: {{ (($me.config).aws).roleArn | required "missing loki config.aws.roleArn" }}
{{- else if eq .Values.cloudProvider "gcp" }}
serviceAccount:
  annotations:
    iam.gke.io/gcp-service-account: {{ (($me.config).gcp).serviceAccountName | required "missing loki config.gcp.serviceAccountName" }}
{{- end }}

{{- end }}

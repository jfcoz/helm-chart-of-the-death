{{/* values for serviceAccount */}}
{{- define "monitoring.loki.serviceAccount" }}
{{- $me := .Values.components.monitoring.loki }}

{{- if eq .Values.components.cloudprovider "aws" }}
serviceAccount:
  annotations:
    eks.amazonaws.com/role-arn: {{ (($me.config).aws).roleArn | required "missing loki config.aws.roleArn" }}
{{- end }}

{{- end }}

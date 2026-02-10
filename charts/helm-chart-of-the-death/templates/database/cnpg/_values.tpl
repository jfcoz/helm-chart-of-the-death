{{/* values */}}
{{- define "database.cnpg.defaultValues" }}
{{- $me := .Values.components.database.cnpg }}
config:
  data:
    # Operator options : https://github.com/cloudnative-pg/cloudnative-pg/blob/main/docs/src/operator_conf.md#available-options

    {{- if include "common.used" .Values.components.monitoring.x509CertificateExporter }}
    # renew before x509-certificate-exporter warningDaysLeft : https://github.com/enix/x509-certificate-exporter/blob/main/deploy/charts/x509-certificate-exporter/values.yaml
    EXPIRING_CHECK_THRESHOLD: "30"
    {{- end }}
{{- end }}

{{/* merged values : default + user  */}}
{{- define "database.cnpg.mergedValues" }}
{{- $me := .Values.components.database.cnpg }}
{{- $defaultValues := include "database.cnpg.defaultValues" . | fromYaml }}
{{- $customValues := $me.values | default dict }}
{{- mergeOverwrite $defaultValues $customValues | toYaml }}
{{- end }}

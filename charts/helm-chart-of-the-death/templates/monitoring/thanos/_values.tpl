{{/* values */}}
{{- define "monitoring.thanos.defaultValues" }}
{{- $me := .Values.components.monitoring.thanos }}
compact:
  enabled: true
  persistence:
    enabled: true
    storageClass: ceph-block
receiver:
  ingestor:
    persistence:
      enabled: true
      storageClass: ceph-block
rule:
  persistence:
    enabled: true
    storageClass: ceph-block
storeGateway:
  persistence:
    enabled: true
    storageClass: ceph-block
objstoreConfig:
  value: |-
    type: S3
    config:
      bucket: thanos-bucket
      endpoint: rook-ceph-rgw-ceph-objectstore.rook-ceph.svc
      region: rook
      access_key: {{ "{{" }} (((lookup "v1" "Secret" {{ $me.namespace | quote }} "thanos-bucket").data).AWS_ACCESS_KEY_ID) | default "QnVja2V0U2VjcmV0Tm90QXZhaWxhYmxlWWV0" | b64dec }}
      secret_key: {{ "{{" }} (((lookup "v1" "Secret" {{ $me.namespace | quote }} "thanos-bucket").data).AWS_SECRET_ACCESS_KEY) | default "QnVja2V0U2VjcmV0Tm90QXZhaWxhYmxlWWV0" | b64dec }}
      insecure: true
{{- end }}

{{/* merged values : default + user  */}}
{{- define "monitoring.thanos.mergedValues" }}
{{- $me := .Values.components.monitoring.thanos }}
{{- $defaultValues := include "monitoring.thanos.defaultValues" . | fromYaml }}
{{- $customValues := $me.values | default dict }}
{{- mergeOverwrite $defaultValues $customValues | toYaml }}
{{- end }}

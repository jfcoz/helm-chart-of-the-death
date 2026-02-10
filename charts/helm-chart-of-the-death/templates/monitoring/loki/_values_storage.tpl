{{/* values for loki.storage */}}
{{- define "monitoring.loki.loki.storage" }}
{{- $me := .Values.components.monitoring.loki }}


{{- if .Capabilities.APIVersions.Has "objectbucket.io/v1alpha1" }}
type: s3
use_thanos_objstore: true
bucketNames:
  chunks: '{{ "{{" }} (((lookup "v1" "ConfigMap" {{ $me.namespace | quote }} "loki-bucket").data).BUCKET_NAME) | default "bucket configmap not available yet" }}'
  # https://github.com/grafana/loki/pull/19882
  ruler: unused
object_store:
  s3:
    access_key_id: '{{ "{{" }} (((lookup "v1" "Secret" {{ $me.namespace | quote }} "loki-bucket").data).AWS_ACCESS_KEY_ID) | default "QnVja2V0U2VjcmV0Tm90QXZhaWxhYmxlWWV0" | b64dec }}'
    secret_access_key: '{{ "{{" }} (((lookup "v1" "Secret" {{ $me.namespace | quote }} "loki-bucket").data).AWS_SECRET_ACCESS_KEY) | default "QnVja2V0U2VjcmV0Tm90QXZhaWxhYmxlWWV0" | b64dec }}'
    endpoint: '{{ "{{" }} (((lookup "v1" "ConfigMap" {{ $me.namespace | quote }} "loki-bucket").data).BUCKET_HOST) | default "bucket configmap not available yet" }}'
    insecure: true
    bucket_lookup_type: path




{{- else if eq .Values.components.cloudProvider "aws" }}
type: s3
use_thanos_objstore: true
bucketNames:
  chunks: {{ (((((.Values.components).monitoring).loki).config).buckets).chunks | required "missing loki.monitoring.config.buckets.chunks" }}
  # https://github.com/grafana/loki/pull/19882
  ruler: unused
object_store:
  s3:
    # access_key_id/secret_access_key not needed, we use the serviceAccount role
    region: {{ $me.config.aws.region | required "missing monitoring.loki.config.aws.region" }}



{{- else if ($me.values.minio).enabled }}
# use_thanos_objstore must be false in case minio is enabled
use_thanos_objstore: false

{{- else }}
# not implemented yet
type: s3
use_thanos_objstore: true
bucketNames:
  chunks: chunks
  ruler: unused
{{- end }}



{{- end }}

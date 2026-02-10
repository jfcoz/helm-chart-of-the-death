{{/* values */}}
{{- define "monitoring.loki.defaultValues" }}
{{- $me := .Values.components.monitoring.loki }}
loki:
  commonConfig:
    {{- if eq $me.config.deploymentMode "SingleBinary" }}
    replication_factor: 1
    {{- else }}
    # we re-define the default, because commonConfig must not be empty, as this would override others commonConfig chart defaults
    replication_factor: 3
    {{- end }}

  storage:
    {{- include "monitoring.loki.loki.storage" . | nindent 4 }}

  limits_config:
    # https://grafana.com/docs/loki/latest/get-started/labels/structured-metadata/
    allow_structured_metadata: true
    volume_enabled: true
    retention_period: 7d

  pattern_ingester:
    # https://grafana.com/docs/plugins/grafana-lokiexplore-app/latest/patterns/
    enabled: true

  compactor:
    # retention_enabled = marquer pour deletion apres le limits_config.retention_period
    retention_enabled: true
    delete_request_store: s3
    # "Get \"https://rook-ceph-rgw-ceph-objectstore.rook-ceph.svc/loki/?location=\": net/http: invalid header field value for \"Authorization\""
    # on utilise le PVC
    #delete_request_store: filesystem
    #working_directory: /var/loki/compactor

  #ruler:
  #  enable_api: true
  #  alertmanager_url: http://...:...

    #compactor:
    #  compaction_interval: 10m
    #  shared_store: aws

  auth_enabled: false

  schemaConfig:
    configs:
    - from: "2025-11-23"
      store: tsdb
      object_store: s3
      schema: v13
      index:
        prefix: loki_index_
        period: 24h

  ingester:
    chunk_encoding: snappy

  tracing:
    enabled: true


{{- template "monitoring.loki.deploymentMode" . }}

{{- template "monitoring.loki.serviceAccount" . }}

{{- end }}

{{/* merged values : default + user  */}}
{{- define "monitoring.loki.mergedValues" }}
{{- $me := .Values.components.monitoring.loki }}
{{- $defaultValues := include "monitoring.loki.defaultValues" . | fromYaml }}
{{- $customValues := $me.values | default dict }}
{{- mergeOverwrite $defaultValues $customValues | toYaml }}
{{- end }}

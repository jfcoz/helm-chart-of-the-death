{{/* values */}}
{{- define "monitoring.tempo.defaultValues" }}
{{- $me := .Values.components.monitoring.tempo }}
traces:
  otlp:
    grpc:
      enabled: true
storage:
  trace:
    backend: s3
    s3:
      bucket: tempo-bucket
      endpoint: rook-ceph-rgw-ceph-objectstore.rook-ceph.svc
      region: rook
      access_key: '{{ "{{" }} (((lookup "v1" "Secret" {{ $me.namespace | quote }} "tempo-bucket").data).AWS_ACCESS_KEY_ID) | default "QnVja2V0U2VjcmV0Tm90QXZhaWxhYmxlWWV0" | b64dec }}'
      secret_key: '{{ "{{" }} (((lookup "v1" "Secret" {{ $me.namespace | quote }} "tempo-bucket").data).AWS_SECRET_ACCESS_KEY) | default "QnVja2V0U2VjcmV0Tm90QXZhaWxhYmxlWWV0" | b64dec }}'
      insecure: true
compactor:
  resources:
    requests:
      memory: 200Mi
    limits:
      memory: 3Gi
  config:
    compaction:
      block_retention: 2h
distributor:
  resources:
    requests:
      memory: 150Mi
    limits:
      memory: 150Mi
ingester:
  config:
    replication_factor: 1
  persistence:
    # persistence is required with boltdb
    enabled: true
    # waiting https://github.com/grafana/helm-charts/pull/3606
    labels:
      {{- if include "common.used" .Values.components.backup.velero }}
      velero.io/exclude-from-backup: "true"
      {{- end }}
    claims:
      - name: data
        size: 10Gi
        storageClass: ceph-block
  replicas: 1
  autoscaling:
    enabled: true
    targetCPUUtilizationPercentage: 90
  resources:
    requests:
      cpu: 20m
      memory: 500Mi
    limits:
      memory: 1000Mi
memcached:
  resources:
    requests:
      memory: 2Mi
    limits:
      memory: 50Mi
querier:
  resources:
    requests:
      memory: 100Mi
    limits:
      memory: 500Mi
queryFrontend:
  resources:
    requests:
      memory: 70Mi
    limits:
      memory: 100Mi
metaMonitoring:
  serviceMonitor:
    enabled: true
prometheusRule:
  enabled: true
metricsGenerator:
  enabled: true
  remote_write:
    - url: http://{{ template "monitoring.kubePrometheusStack.prometheusWriteEndpoint" . }}/api/v1/write
{{- end }}

{{/* merged values : default + user  */}}
{{- define "monitoring.tempo.mergedValues" }}
{{- $me := .Values.components.monitoring.tempo }}
{{- $defaultValues := include "monitoring.tempo.defaultValues" . | fromYaml }}
{{- $customValues := $me.values | default dict }}
{{- mergeOverwrite $defaultValues $customValues | toYaml }}
{{- end }}

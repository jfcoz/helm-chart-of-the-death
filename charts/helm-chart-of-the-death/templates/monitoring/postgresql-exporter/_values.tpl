{{/* values */}}
{{- define "monitoring.postgresqlExporter.defaultValues" }}

serviceAccount:
  create: false
{{- if include "common.used" .Values.components.monitoring.kubePrometheusStack }}
serviceMonitor:
  enabled: true
prometheusRule:
  # no rules by default
  enabled: false
{{- end }}

config:
  extraArgs:
  - --collector.statio_user_indexes
  - --collector.stat_user_tables
  - --collector.stat_statements

  datasource: {}

  datasourceSecret:
    name: postgres-exporter
    key: datasource

resources:
  limits:
    memory: 128Mi
  requests:
    cpu: 50m
    memory: 60Mi

affinity:
  nodeAffinity:
    preferredDuringSchedulingIgnoredDuringExecution:
    - weight: 1
      preference:
        matchExpressions:
        - key: type
          operator: In
          values:
          - spot

tolerations:
- key: "type"
  operator: "Equal"
  value: "spot"
  effect: "NoSchedule"

{{- end }}

{{/* merged values : default + user  */}}
{{- define "monitoring.postgresqlExporter.mergedValues" }}
{{- $me := .Values.components.monitoring.postgresqlExporter }}
{{- $defaultValues := include "monitoring.postgresqlExporter.defaultValues" . | fromYaml }}
{{- $customValues := $me.values | default dict }}
{{- mergeOverwrite $defaultValues $customValues | toYaml }}
{{- end }}

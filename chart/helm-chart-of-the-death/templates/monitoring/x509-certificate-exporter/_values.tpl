{{/* values */}}
{{- define "monitoring.x509CertificateExporter.defaultValues" }}


prometheusRules:
{{- if include "common.used" .Values.components.monitoring.kubePrometheusStack }}
  create: true
{{- else }}
  create: false
{{- end }}

prometheusServiceMonitor:
  {{- if include "common.used" .Values.components.monitoring.kubePrometheusStack }}
  create: true
  {{- else }}
  create: false
  {{- end }}

{{- if eq .Values.kubernetesDistribution "k3s" }}
hostPathsExporter:
  daemonSets:
    masters:
      tolerations:
        - key: master
          operator: Exists
          effect: NoSchedule
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: node-role.kubernetes.io/control-plane 
                operator: In
                values:
                - "true"
      watchDirectories:
        - /var/lib/rancher/k3s/server/tls/
        - /var/lib/rancher/k3s/agent/
    nodes:
      tolerations:
        - key: storage
          operator: Exists
          effect: NoSchedule
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: node-role.kubernetes.io/control-plane 
                operator: NotIn
                values:
                - "true"
      watchDirectories:
        - /var/lib/rancher/k3s/agent/
  resources:
    requests:
      cpu: 1m
      memory: 30M
    limits:
      cpu: 1000m
      memory: 30M
{{- end }}
secretsExporter:
  cache:
    maxDuration: 600
  resources:
    limits:
      cpu: 1000m
{{- end }}

{{/* merged values : default + user  */}}
{{- define "monitoring.x509CertificateExporter.mergedValues" }}
{{- $me := .Values.components.monitoring.x509CertificateExporter }}
{{- $defaultValues := include "monitoring.x509CertificateExporter.defaultValues" . | fromYaml }}
{{- $customValues := $me.values | default dict }}
{{- mergeOverwrite $defaultValues $customValues | toYaml }}
{{- end }}

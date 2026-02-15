{{/* values */}}
{{- define "security.kyverno.defaultValues" }}
{{- $me := .Values.components.security.kyverno }}
admissionController:
  replicas: 3
  tolerations:
  - key: storage
    operator: Exists
    effect: NoSchedule
  topologySpreadConstraints:
    - maxSkew: 1
      topologyKey: topology.kubernetes.io/zone
      whenUnsatisfiable: DoNotSchedule
      labelSelector:
        matchLabels:
          app.kubernetes.io/instance: "{{ .Release.Name }}"
          app.kubernetes.io/component: admission-controller
  {{- if include "common.used" .Values.components.monitoring.kubePrometheusStack }}
  serviceMonitor:
    enabled: true
  {{- end }}
  networkPolicy:
    enabled: true
  container:
    resources:
      requests:
        cpu: 100m
        memory: 150M
      limits:
        memory: 150M
backgroundController:
  resources:
    requests:
      cpu: 1m
cleanupController:
  resources:
    requests:
      cpu: 1m
reportsController:
  resources:
    requests:
      cpu: 1m
      memory: 100Mi
    limits:
      memory: 200Mi
features:
  omitEvents:
    eventTypes:
      - PolicyApplied
test:
  sleep: 1
config:
  webhooks:
    # Exclude system namespaces, cf https://cloud.google.com/kubernetes-engine/docs/how-to/optimize-webhooks?hl=fr#unsafe-webhooks
    namespaceSelector:
      matchExpressions:
      - key: kubernetes.io/metadata.name
        operator: NotIn
        values:
          - kube-system
          - kube-node-lease
{{- end }}


{{/* merged values : default + user  */}}
{{- define "security.kyverno.mergedValues" }}
{{- $me := .Values.components.security.kyverno }}
{{- $defaultValues := include "security.kyverno.defaultValues" . | fromYaml }}
{{- $customValues := $me.values | default dict }}
{{- mergeOverwrite $defaultValues $customValues | toYaml }}
{{- end }}

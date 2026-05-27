{{/* values */}}
{{- define "cni.cilium.defaultValues" }}
{{- $me := .Values.components.cni.cilium }}
cluster:
  name: {{ .Values.general.clusterName }}

k8sServiceHost: {{ .Values.general.kubernetesApi.host | required "missing general.kubernetesApi.host" }}
k8sServicePort: {{ .Values.general.kubernetesApi.port }}

{{- if include "common.used" .Values.components.monitoring.kubePrometheusStack }}
prometheus:
  metricsService: true
  enabled: true
  serviceMonitor:
    enabled: true
dashboards:
  enabled: true
{{- end }}

operator:
  rollOutPods: true
  {{- if include "common.used" .Values.components.monitoring.kubePrometheusStack }}
  dashboards:
    enabled: true
  {{- end }}

rollOutCilliumPods: true

{{- if .Values.features.gatewayAPI.enabled }}
gatewayAPI:
  enabled: true
{{- end }}

{{- if and
  (eq .Values.kubernetesDistribution "k3s")
  (semverCompare ">=1.19.0" $me.chart.version)
}}
# until fix for https://github.com/cilium/cilium/issues/44430
defaultLBServiceIPAM: none
{{- end }}

{{- if semverCompare ">=1.19.0" $me.chart.version }}
# Configure what the response should be to pod egress traffic denied by network policy : icmp instead of none
policyDenyResponse: icmp
{{- end }}

kubeProxyReplacement: true

routingMode: tunnel

tunnelProtocol: geneve

{{- if eq .Values.kubernetesDistribution "k3s" }}
ipam:
  operator:
    # https://docs.cilium.io/en/stable/installation/k3s/
    # match k3s default podCIDR 10.42.0.0/16
    clusterPoolIPv4PodCIDRList:
    - 10.42.0.0/16
{{- end }}

# https://docs.cilium.io/en/stable/configuration/api-rate-limiting/#configuration-parameters
apiRateLimit: |
  endpoint-create=auto-adjust:true,mean-over:25,endpoint-delete=auto-adjust:true,mean-over:25

{{- end }}


{{/* merged values : default + user  */}}
{{- define "cni.cilium.mergedValues" }}
{{- $me := .Values.components.cni.cilium }}
{{- $defaultValues := include "cni.cilium.defaultValues" . | fromYaml }}
{{- $customValues := $me.values | default dict }}
{{- mergeOverwrite $defaultValues $customValues | toYaml }}
{{- end }}

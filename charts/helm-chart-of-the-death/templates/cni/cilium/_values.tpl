{{/* values */}}
{{- define "cni.cilium.defaultValues" }}
{{- $me := .Values.components.cni.cilium }}
cluster:
  name: {{ .Values.global.clusterName }}

k8sServiceHost: {{ .Values.global.kubernetesApi.host | required "missing global.kubernetesApi.host" }}
k8sServicePort: {{ .Values.global.kubernetesApi.port }}

updateStrategy:
  rollingUpdate:
    maxUnavailable: 33%

envoy:
  updateStrategy:
    rollingUpdate:
      maxUnavailable: 33%

{{- if semverCompare ">=1.19.0" $me.chartVersion }}
# netork policy : reject instead of drop
serviceNoBackendResponse: icmp
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

{{- end }}


{{/* merged values : default + user  */}}
{{- define "cni.cilium.mergedValues" }}
{{- $me := .Values.components.cni.cilium }}
{{- $defaultValues := include "cni.cilium.defaultValues" . | fromYaml }}
{{- $customValues := $me.values | default dict }}
{{- mergeOverwrite $defaultValues $customValues | toYaml }}
{{- end }}

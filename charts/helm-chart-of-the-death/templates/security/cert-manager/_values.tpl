{{/* values */}}
{{- define "security.certManager.defaultValues" }}
{{- $me := .Values.components.security.certManager }}
installCRDs: true
resources:
  requests:
    memory: 150Mi
    cpu: 3m
cainjector:
  resources:
    requests:
      memory: 170Mi
      cpu: 2m
webhook:
  resources:
    requests:
      memory: 30Mi
      cpu: 1m

config:
  {{- if and 
            ( (.Values.features.gatewayAPI).enabled )
            (include "common.used" .Values.components.cni.cilium)
  }}
  {{- if semverCompare ">=1.21.0" $me.chart.version }}
  gatewayAPI:
    enabled: true
  {{- else }}
  enableGatewayAPI: true
  {{- end }}
  {{- end }}

{{- end }}


{{/* merged values : default + user  */}}
{{- define "security.certManager.mergedValues" }}
{{- $me := .Values.components.security.certManager }}
{{- $defaultValues := include "security.certManager.defaultValues" . | fromYaml }}
{{- $customValues := $me.values | default dict }}
{{- mergeOverwrite $defaultValues $customValues | toYaml }}
{{- end }}

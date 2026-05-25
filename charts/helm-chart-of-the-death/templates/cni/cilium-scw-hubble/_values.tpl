{{/* values */}}
{{- define "cni.ciliumScwHubble.defaultValues" }}
{{- $me := .Values.components.cni.ciliumScwHubble }}
# From https://github.com/cilium/cilium/issues/31357#issuecomment-3746772007
hubble:
  export:
    dynamic:
      enabled: true
      config:
        enabled: true
        content:
          # https://docs.cilium.io/en/stable/_api/v1/flow/README/
          - name: "l7-http-stdout"
            filePath: "/dev/stdout"
            # imaginative value for stream to not rotate /dev/stdout
            fileMaxSizeMb: 2137
            fileMaxBackups: 0
            fieldMask:
              - time
              - uuid
              - verdict
              - l7.http.code
              - l7.http.method
              - l7.http.url
              - l7.http.protocol
              - IP
              - destination.pod_name
              - source.pod_name
              - l7.type
              - l7.latency_ns
              - l7.http.headers
            # https://github.com/cilium/cilium/blob/main/pkg/monitor/api/types.go#L51
            includeFilters:
              - event_type:
                  - type: 129
{{- end }}


{{/* merged values : default + user  */}}
{{- define "cni.ciliumScwHubble.mergedValues" }}
{{- $me := .Values.components.cni.ciliumScwHubble }}
{{- $defaultValues := include "cni.ciliumScwHubble.defaultValues" . | fromYaml }}
{{- $customValues := $me.values | default dict }}
{{- mergeOverwrite $defaultValues $customValues | toYaml }}
{{- end }}

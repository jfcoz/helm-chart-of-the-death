{{/* values */}}
{{- define "security.falcoTalon.defaultValues" }}
{{- $me := .Values.components.security.falcoTalon }}

image:
  # release 0.3 is from 2025
  # in 0.3 k8sevents is not emmiting the event in the application namespace
  tag: 23e1ca0

# TODO: topologySpreadConstraints not implemented yet

config:
  printAllEvents: true

  rulesOverride: |
    - action: Terminate Pod
      actionner: kubernetes:terminate
      parameters:
        ignore_daemonsets: true
        ignore_statefulsets: true
        grace_period_seconds: 20

    - rule: test rule
      description: test rule description
      match:
        rules:
          - Unexpected outbound connection destination
          - Drop and execute new binary in container
      actions:
        - action: Terminate Pod
          parameters:
            gracePeriods: 2

{{- end }}


{{/* merged values : default + user  */}}
{{- define "security.falcoTalon.mergedValues" }}
{{- $me := .Values.components.security.falcoTalon }}
{{- $defaultValues := include "security.falcoTalon.defaultValues" . | fromYaml }}
{{- $customValues := $me.values | default dict }}
{{- mergeOverwrite $defaultValues $customValues | toYaml }}
{{- end }}

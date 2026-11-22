{{/* values */}}
{{- define "security.falcoTalon.defaultValues" }}
{{- $me := .Values.components.security.falcoTalon }}
replicaCount: 1

# TODO: topologySpreadConstraints not implemented yet

config:
  deduplication:
    # needs quote, else default true replace false
    # leaderElection try to use the falco namespace
    leaderElection: "false"
  printAllEvents: true


{{- end }}


{{/* merged values : default + user  */}}
{{- define "security.falcoTalon.mergedValues" }}
{{- $me := .Values.components.security.falcoTalon }}
{{- $defaultValues := include "security.falcoTalon.defaultValues" . | fromYaml }}
{{- $customValues := $me.values | default dict }}
{{- mergeOverwrite $defaultValues $customValues | toYaml }}
{{- end }}

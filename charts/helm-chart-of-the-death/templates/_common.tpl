{{/* common.managed: check if we manage this component */}}
{{- define "common.managed" }}
{{- ternary "true" "" .managed -}}
{{- end }}

{{/* common.used: check if we managed the component or it is already installed (used) */}}
{{- define "common.used" }}
{{- ternary "true" "" (or .managed (.used | default false)) -}}
{{- end }}

{{/*
common.fluxcd.release: merge default and component helmrelease options
args: $ and $me
*/}}
{{- define "common.fluxcd.release" }}
{{- toYaml (mergeOverwrite (index . 0).Values.general.fluxcd.release (index . 1).release) }}
{{- end }}

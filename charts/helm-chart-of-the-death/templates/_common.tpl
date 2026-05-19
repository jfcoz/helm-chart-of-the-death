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
{{- toYaml (mergeOverwrite (index . 0).Values.general.fluxcd.release ((index . 1).release)) }}
{{- end }}

{{/*
common.fluxcd.chartSpec: HelmRelease spec.chart or spec.chartSpec
args: $ and $me
*/}}
{{- define "common.fluxcd.chartSpec" }}
{{- $ := (index . 0) }}
{{- $me := (index . 1) }}

{{- /* search repo url */}}
{{- /* TODO: factorize as an include, same as oci_repositories.yaml */}}
{{ $chartUrl := "" }}
{{- range ($.Values.repositories) }}
{{- if (eq .name $me.chart.repository) }}
{{- $chartUrl = .url }}
{{- end }}
{{- end }}

{{- if (regexMatch "^(oci)://" $chartUrl) }}
chartRef:
  kind: OCIRepository
  name: {{ printf "%s-%s" $me.chart.repository $me.chart.name | quote }}
  namespace: {{ $.Release.Namespace }}
{{- else }}
chart:
  spec:
    chart: {{ $me.chart.name }}
    # each major contains upgrade process in changelog
    version: {{ $me.chart.version | quote }}
    sourceRef:
      kind: HelmRepository
      name: {{ $me.chart.repository | quote }}
      namespace: {{ $.Release.Namespace }}
    interval: 1h
{{- end }}
{{- end }}

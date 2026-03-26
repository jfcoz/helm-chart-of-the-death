{{/* common.storage.rwo: default ReadWriteOnce storage class to use */}}
{{- define "common.storage.rwo" }}
{{- if include "common.used" .Values.components.storage.rook -}}
ceph-block
{{- else if eq .Values.cloudProvider "scw" -}}
sbs-default
{{- else }}
{{- fail "unsupported cloudProvider" }}
{{- end }}
{{- end }}

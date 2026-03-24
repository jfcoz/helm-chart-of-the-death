{{/* default values */}}
{{- define "backup.velero.backupStorageLocation" }}
{{- $me := .Values.components.backup.velero }}

{{- if eq .Values.cloudProvider "scw" }}
- name: default
  provider: velero.io/aws
  bucket: {{ $me.config.bucket | required "missing components.backup.velero.config.bucket" }}
  config:
    {{- if $me.config.aws.endpoint }}
    s3Url: "https://{{ $me.config.aws.endpoint }}"
    {{- end }}
    s3ForcePathStyle: "true"
    region: {{ $me.config.aws.region | required "missing components.backup.velero.config.aws.region" }}
    # https://github.com/vmware-tanzu/velero/issues/7952#issuecomment-2197234521
    checksumAlgorithm: ""

{{- else }}
# TODO condition/variables
- name: default
  provider: velero.io/aws
  bucket: velero-k3s
  config:
    # TODO
    s3Url: "https://s3.sbg.io.cloud.ovh.net"
    s3ForcePathStyle: "true"
    region: "sbg"
    # https://github.com/vmware-tanzu/velero/issues/7952#issuecomment-2197234521
    checksumAlgorithm: ""

{{- end }}


{{- end }}

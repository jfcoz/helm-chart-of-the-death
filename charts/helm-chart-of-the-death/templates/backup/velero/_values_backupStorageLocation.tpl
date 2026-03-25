{{/* default values */}}
{{- define "backup.velero.backupStorageLocation" }}
{{- $me := .Values.components.backup.velero }}

- name: default
  {{- if $me.config.aws }}
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

    {{- if $me.config.encryption.enabled }}

    {{- if or
             (eq .Values.cloudProvider "scw")
    }}
    serverSideEncryption: AES256
    {{- else }}
    {{- fail "unknown serverSideEncryption for {{ .Values.cloudProvider }}" }}
    {{- end }}

    customerKeyEncryptionFile: /encryption/{{ $me.config.encryption.keyName }}
    {{- end }}

  {{- else }}
  {{- fail "Unsupported velero provider" }}
  {{- end }}


{{- end }}

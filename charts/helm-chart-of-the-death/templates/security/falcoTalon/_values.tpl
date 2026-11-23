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
          - Directory traversal monitored file read
          - Read sensitive file trusted after startup
          - Read sensitive file untrusted
          - Run shell untrusted
          - System user interactive
          - Terminal shell in container
          #- Contact K8S API Server From Container
          - Netcat Remote Code Execution in Container
          - Search Private Keys or Passwords
          - Clear Log Activities
          - Remove Bulk Data from Disk
          - Create Symlink Over Sensitive Files
          - Create Hardlink Over Sensitive Files
          - Packet socket created in container
          - Redirect STDOUT/STDIN to Network Connection in Container
          - Linux Kernel Module Injection Detected
          - Debugfs Launched in Privileged Container
          - Detect release_agent File Container Escapes
          - PTRACE attached to process
          - PTRACE anti-debug attempt
          - Find AWS Credentials
          - Execution from /dev/shm
          - Drop and execute new binary in container
          - Disallowed SSH Connection Non Standard Port
          - Fileless execution via memfd_create

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

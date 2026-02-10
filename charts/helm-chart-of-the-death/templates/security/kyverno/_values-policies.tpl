{{/* values */}}
{{- define "security.kyverno.policies.defaultValues.policyExclude" }}
{{- $me := .Values.components.security.kyverno }}
disallow-capabilities:
  any:
  {{- if include "common.used" .Values.components.storage.rook }}
  - resources:
      namespaces:
      - {{ .Values.components.storage.rook.namespace }}
      kinds:
      - Pod
      names:
      - "rook-ceph.cephfs.csi.ceph.com-nodeplugin*"
      - "rook-ceph.rbd.csi.ceph.com-nodeplugin*"
  {{- end }}
  {{- if include "common.used" .Values.components.monitoring.k8sMonitoring }}
  - resources:
      namespaces:
      - {{ .Values.components.monitoring.k8sMonitoring.namespace }}
      kinds:
      - Pod
      names:
      - "k8s-monitoring-alloy-logs-*"
  {{- end }}
  {{- if eq .Values.kubernetesDistribution "k3s" }}
  - resources:
      namespaces:
      - kube-system
      kinds:
      - Pod
      names:
      - "svclb-nginx-ingress-ingress-nginx-controller-*"
  {{- end }}
disallow-host-namespaces:
  any:
  {{- if include "common.used" .Values.components.storage.rook }}
  - resources:
      namespaces:
      - {{ .Values.components.storage.rook.namespace }}
      # TODO: split more specific component
  {{- end }}
  {{- if include "common.used" .Values.components.monitoring.kubePrometheusStack }}
  - resources:
      namespaces:
      - {{ .Values.components.monitoring.kubePrometheusStack.namespace }}
      # TODO: split more specific component
  {{- end }}
  {{- if include "common.used" .Values.components.security.trivy }}
  - resources:
      namespaces:
      - {{ .Values.components.security.trivy.namespace }}
      kinds:
      - Pod
      names:
      - "node-collector-*"
  {{- end }}
  {{- if include "common.used" .Values.components.monitoring.smartctlExporter }}
  - resources:
      namespaces:
      - {{ .Values.components.monitoring.smartctlExporter.namespace }}
  {{- end }}
disallow-host-path:
  any:
  # TODO: split more specific component
  {{- if include "common.used" .Values.components.storage.rook }}
  - resources:
      namespaces:
      - {{ .Values.components.storage.rook.namespace }}
  {{- end }}
  {{- if include "common.used" .Values.components.monitoring.promtail }}
  - resources:
      namespaces:
      - {{ .Values.components.monitoring.promtail.namespace }}
      kinds:
      - Pod
  {{- end }}
  {{- if include "common.used" .Values.components.monitoring.x509CertificateExporter }}
  - resources:
      namespaces:
      - {{ .Values.components.monitoring.x509CertificateExporter.namespace }}
      kinds:
      - Pod
  {{- end }}
  {{- if include "common.used" .Values.components.monitoring.k8sMonitoring }}
  - resources:
      namespaces:
      - {{ .Values.components.monitoring.k8sMonitoring.namespace }}
      kinds:
      - Pod
      names:
      - "k8s-monitoring-alloy-logs-*"
  {{- end }}
  {{- if include "common.used" .Values.components.monitoring.kubePrometheusStack }}
  - resources:
      namespaces:
      - {{ .Values.components.monitoring.kubePrometheusStack.namespace }}
      kinds:
      - DaemonSet
      names:
      - "prometheus-prometheus-node-exporter"
  - resources:
      namespaces:
      - {{ .Values.components.monitoring.kubePrometheusStack.namespace }}
      kinds:
      - Pod
      names:
      - "prometheus-prometheus-node-exporter-*"
  {{- end }}
  {{- if include "common.used" .Values.components.security.trivy }}
  - resources:
      namespaces:
      - {{ .Values.components.security.trivy.namespace }}
      kinds:
      - Pod
      names:
      - "node-collector-*"
  {{- end }}
  {{- if include "common.used" .Values.components.monitoring.kubePrometheusStack }}
  - resources:
      namespaces:
      - {{ .Values.components.monitoring.smartctlExporter.namespace }}
  {{- end }}
  {{- if include "common.used" .Values.components.backup.velero }}
  - resources:
      namespaces:
      - {{ .Values.components.backup.velero.namespace }}
      kinds:
      - Pod
      names:
      - "node-agent-*"
      {{- if dig "configuration" "defaultVolumesToFsBackup" "false" (include "backup.velero.mergedValues" . | fromYaml) }}
      - "velero-*"
      {{- end }}
  {{- end }}
  {{- if include "common.used" .Values.components.security.falco }}
  - resources:
      namespaces:
      - {{ .Values.components.security.falco.namespace }}
      kinds:
      - Pod
      names:
      - "falco-*"
      - "infra-falco-falco-*"
  {{- end }}
disallow-host-ports:
  any:
  {{- if include "common.used" .Values.components.monitoring.kubePrometheusStack }}
  - resources:
      namespaces:
      - {{ .Values.components.monitoring.kubePrometheusStack.namespace }}
      kinds:
      - DaemonSet
      names:
      - "prometheus-prometheus-node-exporter"
  - resources:
      namespaces:
      - {{ .Values.components.monitoring.kubePrometheusStack.namespace }}
      kinds:
      - Pod
      names:
      - "prometheus-prometheus-node-exporter-*"
  {{- end }}
  {{- if eq .Values.kubernetesDistribution "k3s" }}
  - resources:
      namespaces:
      - kube-system
      kinds:
      - Pod
      names:
      - "svclb-nginx-ingress-ingress-nginx-controller-*"
  {{- end }}
  {{- if include "common.used" .Values.components.monitoring.kubePrometheusStack }}
  - resources:
      namespaces:
      - {{ .Values.components.monitoring.smartctlExporter.namespace }}
  {{- end }}
disallow-privileged-containers:
  any:
  {{- if include "common.used" .Values.components.storage.rook }}
  - resources:
      namespaces:
      - {{ .Values.components.storage.rook.namespace }}
      # TODO: split more specific component
  {{- end }}
  {{- if include "common.used" .Values.components.monitoring.smartctlExporter }}
  - resources:
      namespaces:
      - {{ .Values.components.monitoring.smartctlExporter.namespace }}
  {{- end }}
  {{- if include "common.used" .Values.components.security.falco }}
  - resources:
      namespaces:
      - {{ .Values.components.security.falco.namespace }}
      kinds:
      - Pod
      names:
      - "falco-*"
      - "infra-falco-falco-*"
  {{- end }}
restrict-sysctls:
  any:
  {{- if eq .Values.kubernetesDistribution "k3s" }}
  - resources:
      namespaces:
      - kube-system
      kinds:
      - Pod
      - DaemonSet
      names:
      - "svclb-nginx-ingress-ingress-nginx-controller-*"
  {{- end }}
{{- end }}

{{/* 
  helm merge does not append list so we do it ourself 
  TODO: make a generic deepMergeAppend function
*/}} 
{{- define "security.kyverno.policies.mergedPolicyExclude" }}
{{- $me := .Values.components.security.kyverno }}
{{- $defaulPolicyExclude := include "security.kyverno.policies.defaultValues.policyExclude" . | fromYaml }}
{{- $customPolicyExclude := $me.policyExclude | default dict }}
{{- $defaultPolicyList := keys $defaulPolicyExclude }}
{{- $customPolicyList := keys $customPolicyExclude }}
{{- $policyList := concat $defaultPolicyList $customPolicyList | uniq }}
policyExclude:
{{- range $policyName := $policyList }}
  {{- $defaultAny := dig $policyName "any" "" $defaulPolicyExclude }}
  {{- $customAny := dig $policyName "any" "" $customPolicyExclude }}
  {{- if or
            $defaultAny
            $customAny
  }}
  {{ $policyName }}:
    any:
      {{- if $defaultAny }}
      {{- $defaultAny | toYaml | nindent 6 }}
      {{- end }}
      {{- if $customAny }}
      {{- $customAny | toYaml | nindent 6 }}
      {{- end }}
  {{- end }}
{{- end }}
debug:
{{ $policyList | toYaml | nindent 2 }}
{{- end }}


{{/* values */}}
{{- define "security.kyverno.policies.defaultValues" }}
{{- $me := .Values.components.security.kyverno }}
# default failurePolicy Fail will block is webhook made an error. Ignore will continue
failurePolicy: Ignore
# validationFailureAction : Audit or Enforce
validationFailureAction: Enforce

{{- template "security.kyverno.policies.mergedPolicyExclude" . }}
{{- end }}


{{/* merged values : default + user  */}}
{{- define "security.kyverno.policies.mergedValues" }}
{{- $me := .Values.components.security.kyverno }}
{{- $defaultValues := include "security.kyverno.policies.defaultValues" . | fromYaml }}
{{- $customValues := $me.values | default dict }}
{{- merge (deepCopy $defaultValues) $customValues | toYaml }}
{{- end }}

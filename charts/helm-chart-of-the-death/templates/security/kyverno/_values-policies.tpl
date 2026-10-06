{{/* policy excludes */}}
{{- define "security.kyverno.policies.defaultValues.policyExclude" }}
{{- $me := .Values.components.security.kyverno }}
disallow-capabilities:
  any:
  {{- if include "common.used" .Values.components.cni.cilium }}
  - resources:
      namespaces:
      - {{ .Values.components.cni.cilium.namespace }}
      kinds:
      - Pod
      names:
      - "cilium-*"
      - "cilium-envoy-*"
  {{- end }}
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
  {{- if and
         (include "common.used" .Values.components.monitoring.datadog)
         ( or
             (eq ((.Values.components.monitoring.datadog.values).discovery).enabled nil)
             ((.Values.components.monitoring.datadog.values).discovery).enabled
         )
  }}
  {{- /* if not set, discovery is enabled by default */}}
  - resources:
      namespaces:
      - {{ .Values.components.monitoring.datadog.namespace }}
      kinds:
      - DaemonSet
      - Pod
      names:
      - "datadog"
      - "datadog-*"
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
  {{- if eq .Values.cloudProvider "scw" }}
  - resources:
      namespaces:
      - kube-system
      kinds:
      - Pod
      names:
      - "csi-node-*"
  {{- end }}
  {{- if eq .Values.kubernetesDistribution "k3s" }}
  - resources:
      namespaces:
      - kube-system
      kinds:
      - Pod
      names:
      - "svclb-*"
  {{- end }}

disallow-host-namespaces:
  any:
  {{- if include "common.used" .Values.components.cni.cilium }}
  - resources:
      namespaces:
      - {{ .Values.components.cni.cilium.namespace }}
      kinds:
      - Pod
      names:
      - "cilium-*"
  {{- end }}
  {{- if include "common.used" .Values.components.storage.rook }}
  - resources:
      namespaces:
      - {{ .Values.components.storage.rook.namespace }}
      # TODO: split more specific component
  {{- end }}
  {{- if include "common.used" .Values.components.monitoring.datadog }}
  - resources:
      namespaces:
      - {{ .Values.components.monitoring.datadog.namespace }}
      kinds:
      - DaemonSet
      - Pod
      names:
      - "datadog"
      - "datadog-*"
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
  {{- if eq .Values.cloudProvider "scw" }}
  - resources:
      namespaces:
      - kube-system
      kinds:
      - Pod
      names:
      - "csi-node-*"
  {{- end }}
  {{- if eq .Values.cloudProvider "scw" }}
  - resources:
      namespaces:
      - kube-system
      kinds:
      - Pod
      names:
      - "konnectivity-agent-*"
  {{- end }}

disallow-host-path:
  any:
  # TODO: split more specific component
  {{- if include "common.used" .Values.components.cni.cilium }}
  - resources:
      namespaces:
      - {{ .Values.components.cni.cilium.namespace }}
      kinds:
      - Pod
      names:
      - "cilium-*"
  {{- end }}
  {{- if include "common.used" .Values.components.storage.rook }}
  - resources:
      namespaces:
      - {{ .Values.components.storage.rook.namespace }}
  {{- end }}
  {{- if include "common.used" .Values.components.monitoring.datadog }}
  - resources:
      namespaces:
      - {{ .Values.components.monitoring.datadog.namespace }}
      kinds:
      - DaemonSet
      names:
      - "datadog"
  {{- end }}
  {{- if include "common.used" .Values.components.monitoring.datadog }}
  - resources:
      namespaces:
      - {{ .Values.components.monitoring.datadog.namespace }}
      kinds:
      - DaemonSet
      - Pod
      names:
      - "datadog"
      - "datadog-*"
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
  {{- if eq .Values.cloudProvider "scw" }}
  - resources:
      namespaces:
      - kube-system
      kinds:
      - Pod
      names:
      - "csi-node-*"
  {{- end }}

disallow-host-ports:
  any:
  {{- if include "common.used" .Values.components.cni.cilium }}
  - resources:
      namespaces:
      - {{ .Values.components.cni.cilium.namespace }}
      kinds:
      - Pod
      names:
      - "cilium-*"
      - "cilium-envoy-*"
      - "cilium-operator-*"
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
  {{- if include "common.used" .Values.components.cni.cilium }}
  - resources:
      namespaces:
      - {{ .Values.components.cni.cilium.namespace }}
      kinds:
      - Pod
      names:
      - "cilium-*"
  {{- end }}
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
  {{- if eq .Values.cloudProvider "scw" }}
  - resources:
      namespaces:
      - kube-system
      kinds:
      - Pod
      names:
      - "csi-node-*"
  {{- end }}

disallow-selinux:
  any:
  {{- if include "common.used" .Values.components.cni.cilium }}
  - resources:
      namespaces:
      - {{ .Values.components.cni.cilium.namespace }}
      kinds:
      - Daemonset
      names:
      - "cilium"
  - resources:
      namespaces:
      - {{ .Values.components.cni.cilium.namespace }}
      kinds:
      - Pod
      names:
      - "cilium-*"
      - "cilium-envoy-*"
  {{- end }}

restrict-seccomp:
  any:
  {{- if include "common.used" .Values.components.cni.cilium }}
  - resources:
      namespaces:
      - {{ .Values.components.cni.cilium.namespace }}
      kinds:
      - DaemonSet
      names:
      - "cilium"
  - resources:
      namespaces:
      - {{ .Values.components.cni.cilium.namespace }}
      kinds:
      - Pod
      names:
      - "cilium-*"
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
{{- end }}





{{/* policies.kyverno.io/v1 policyexceptions */}}
{{- define "security.kyverno.policies.defaultValues.policyExceptions" }}
{{- $me := .Values.components.security.kyverno }}
- apiVersion: policies.kyverno.io/v1
  kind: PolicyException
  metadata:
    name: exclude-coredns
    namespace: infra-kyverno
    annotations:
      helm.sh/resource-policy: keep
  spec:
    policyRefs:
      - name: disallow-host-path
        kind: ValidatingPolicy
    matchConditions:
      - name: skip-by-name-and-namespace
        expression: "object.metadata.name.startsWith('coredns') && object.metadata.namespace == 'kube-system'"

- apiVersion: policies.kyverno.io/v1
  kind: PolicyException
  metadata:
    name: exclude-kube-proxy
    namespace: infra-kyverno
    annotations:
      helm.sh/resource-policy: keep
  spec:
    policyRefs:
      - name: disallow-host-namespaces
        kind: ValidatingPolicy
      - name: disallow-host-path
        kind: ValidatingPolicy
      - name: disallow-privileged-containers
        kind: ValidatingPolicy
    matchConditions:
      - name: skip-by-name-and-namespace
        expression: "object.metadata.name.startsWith('kube-proxy') && object.metadata.namespace == 'kube-system'"


{{- if include "common.used" .Values.components.cni.cilium }}
- apiVersion: policies.kyverno.io/v1
  kind: PolicyException
  metadata:
    name: exclude-cilium-agent
    namespace: infra-kyverno
    annotations:
      helm.sh/resource-policy: keep
  spec:
    policyRefs:
      - name: disallow-capabilities
        kind: ValidatingPolicy
      - name: disallow-host-namespaces
        kind: ValidatingPolicy
      - name: disallow-host-path
        kind: ValidatingPolicy
      - name: disallow-host-ports
        kind: ValidatingPolicy
      - name: disallow-privileged-containers
        kind: ValidatingPolicy
      - name: disallow-selinux
        kind: ValidatingPolicy
      - name: restrict-apparmor-profiles
        kind: ValidatingPolicy
      - name: restrict-seccomp
        kind: ValidatingPolicy
    matchConditions:
      - name: skip-by-name-and-namespace-and-app
        expression: "object.metadata.name.startsWith('cilium') && object.metadata.namespace == '{{ .Values.components.cni.cilium.namespace }}' && object.metadata.labels['app.kubernetes.io/name']=='cilium-agent'"
- apiVersion: policies.kyverno.io/v1
  kind: PolicyException
  metadata:
    name: exclude-cilium-envoy
    namespace: infra-kyverno
    annotations:
      helm.sh/resource-policy: keep
  spec:
    policyRefs:
      - name: disallow-capabilities
        kind: ValidatingPolicy
      - name: disallow-host-namespaces
        kind: ValidatingPolicy
      - name: disallow-host-path
        kind: ValidatingPolicy
      - name: disallow-host-ports
        kind: ValidatingPolicy
      - name: disallow-selinux
        kind: ValidatingPolicy
      - name: restrict-apparmor-profiles
        kind: ValidatingPolicy
    matchConditions:
      - name: skip-by-name-and-namespace-and-app
        expression: "object.metadata.name.startsWith('cilium-envoy') && object.metadata.namespace == '{{ .Values.components.cni.cilium.namespace }}' && object.metadata.labels['app.kubernetes.io/name']=='cilium-envoy'"
- apiVersion: policies.kyverno.io/v1
  kind: PolicyException
  metadata:
    name: exclude-cilium-operator
    namespace: infra-kyverno
    annotations:
      helm.sh/resource-policy: keep
  spec:
    policyRefs:
      - name: disallow-host-namespaces
        kind: ValidatingPolicy
      - name: disallow-host-ports
        kind: ValidatingPolicy
    matchConditions:
      - name: skip-by-name-and-namespace
        expression: "object.metadata.name.startsWith('cilium-operator') && object.metadata.namespace == '{{ .Values.components.cni.cilium.namespace }}'"
{{- end }}


{{- if include "common.used" .Values.components.storage.rook }}
- apiVersion: policies.kyverno.io/v1
  kind: PolicyException
  metadata:
    name: rook-ceph-objectstore
    namespace: infra-kyverno
    annotations:
      helm.sh/resource-policy: keep
  spec:
    policyRefs:
      - name: disallow-host-path
        kind: ValidatingPolicy
    matchConditions:
      - name: skip-by-name-and-namespace
        expression: "object.metadata.name.startsWith('rook-ceph-rgw-ceph-objectstore') && object.metadata.namespace == '{{ .Values.components.storage.rook.namespace }}'"
- apiVersion: policies.kyverno.io/v1
  kind: PolicyException
  metadata:
    name: rook-ceph-osd
    namespace: infra-kyverno
    annotations:
      helm.sh/resource-policy: keep
  spec:
    policyRefs:
      - name: disallow-privileged-containers
        kind: ValidatingPolicy
      - name: disallow-host-path
        kind: ValidatingPolicy
    matchConditions:
      - name: skip-by-name-and-namespace
        expression: "object.metadata.name.startsWith('rook-ceph-osd') && object.metadata.namespace == '{{ .Values.components.storage.rook.namespace }}'"
- apiVersion: policies.kyverno.io/v1
  kind: PolicyException
  metadata:
    name: rook-ceph-exporter
    namespace: infra-kyverno
    annotations:
      helm.sh/resource-policy: keep
  spec:
    policyRefs:
      - name: disallow-host-path
        kind: ValidatingPolicy
    matchConditions:
      - name: skip-by-name-and-namespace
        expression: "object.metadata.name.startsWith('rook-ceph-exporter') && object.metadata.namespace == '{{ .Values.components.storage.rook.namespace }}'"
- apiVersion: policies.kyverno.io/v1
  kind: PolicyException
  metadata:
    name: rook-ceph-mds
    namespace: infra-kyverno
    annotations:
      helm.sh/resource-policy: keep
  spec:
    policyRefs:
      - name: disallow-host-path
        kind: ValidatingPolicy
    matchConditions:
      - name: skip-by-name-and-namespace
        expression: "object.metadata.name.startsWith('rook-ceph-mds') && object.metadata.namespace == '{{ .Values.components.storage.rook.namespace }}'"
- apiVersion: policies.kyverno.io/v1
  kind: PolicyException
  metadata:
    name: rook-ceph-mgr
    namespace: infra-kyverno
    annotations:
      helm.sh/resource-policy: keep
  spec:
    policyRefs:
      - name: disallow-host-path
        kind: ValidatingPolicy
    matchConditions:
      - name: skip-by-name-and-namespace
        expression: "object.metadata.name.startsWith('rook-ceph-mgr') && object.metadata.namespace == '{{ .Values.components.storage.rook.namespace }}'"
- apiVersion: policies.kyverno.io/v1
  kind: PolicyException
  metadata:
    name: rook-ceph-mon
    namespace: infra-kyverno
    annotations:
      helm.sh/resource-policy: keep
  spec:
    policyRefs:
      - name: disallow-host-path
        kind: ValidatingPolicy
    matchConditions:
      - name: skip-by-name-and-namespace
        expression: "object.metadata.name.startsWith('rook-ceph-mon') && object.metadata.namespace == '{{ .Values.components.storage.rook.namespace }}'"
- apiVersion: policies.kyverno.io/v1
  kind: PolicyException
  metadata:
    name: rook-ceph-csi-ctrlplugin-cephfs
    namespace: infra-kyverno
    annotations:
      helm.sh/resource-policy: keep
  spec:
    policyRefs:
      - name: disallow-host-path
        kind: ValidatingPolicy
    matchConditions:
      - name: skip-by-name-and-namespace
        expression: "object.metadata.name.startsWith('rook-ceph.cephfs.csi.ceph.com-ctrlplugin') && object.metadata.namespace == '{{ .Values.components.storage.rook.namespace }}'"
- apiVersion: policies.kyverno.io/v1
  kind: PolicyException
  metadata:
    name: rook-ceph-csi-ctrlplugin-rbd
    namespace: infra-kyverno
    annotations:
      helm.sh/resource-policy: keep
  spec:
    policyRefs:
      - name: disallow-host-path
        kind: ValidatingPolicy
    matchConditions:
      - name: skip-by-name-and-namespace
        expression: "object.metadata.name.startsWith('rook-ceph.rbd.csi.ceph.com-ctrlplugin') && object.metadata.namespace == '{{ .Values.components.storage.rook.namespace }}'"
- apiVersion: policies.kyverno.io/v1
  kind: PolicyException
  metadata:
    name: rook-ceph-csi-nodeplugin-cephfs
    namespace: infra-kyverno
    annotations:
      helm.sh/resource-policy: keep
  spec:
    policyRefs:
      - name: disallow-capabilities
        kind: ValidatingPolicy
      - name: disallow-host-namespaces
        kind: ValidatingPolicy
      - name: disallow-host-path
        kind: ValidatingPolicy
      - name: disallow-privileged-containers
        kind: ValidatingPolicy
    matchConditions:
      - name: skip-by-name-and-namespace
        expression: "object.metadata.name.startsWith('rook-ceph.cephfs.csi.ceph.com-nodeplugin') && object.metadata.namespace == '{{ .Values.components.storage.rook.namespace }}'"
- apiVersion: policies.kyverno.io/v1
  kind: PolicyException
  metadata:
    name: rook-ceph-csi-nodeplugin-rbd
    namespace: infra-kyverno
    annotations:
      helm.sh/resource-policy: keep
  spec:
    policyRefs:
      - name: disallow-capabilities
        kind: ValidatingPolicy
      - name: disallow-host-namespaces
        kind: ValidatingPolicy
      - name: disallow-host-path
        kind: ValidatingPolicy
      - name: disallow-privileged-containers
        kind: ValidatingPolicy
    matchConditions:
      - name: skip-by-name-and-namespace
        expression: "object.metadata.name.startsWith('rook-ceph.rbd.csi.ceph.com-nodeplugin') && object.metadata.namespace == '{{ .Values.components.storage.rook.namespace }}'"
{{- end }}

{{- if include "common.used" .Values.components.monitoring.datadog }}
- apiVersion: policies.kyverno.io/v1
  kind: PolicyException
  metadata:
    name: datadog-agent
    namespace: infra-kyverno
    annotations:
      helm.sh/resource-policy: keep
  spec:
    policyRefs:
      {{- if and
             (include "common.used" .Values.components.monitoring.datadog)
             ( or
                 (eq ((.Values.components.monitoring.datadog.values).discovery).enabled nil)
                 ((.Values.components.monitoring.datadog.values).discovery).enabled
             )
      }}
      {{- /* if not set, discovery is enabled by default */}}
      - name: disallow-capabilities
        kind: ValidatingPolicy
      {{- end }}
      - name: disallow-host-namespaces
        kind: ValidatingPolicy
      - name: disallow-host-path
        kind: ValidatingPolicy
      - name: restrict-apparmor-profiles
        kind: ValidatingPolicy
    matchConditions:
      - name: skip-by-name-and-namespace-and-component
        expression: "object.metadata.name.startsWith('datadog') && object.metadata.namespace == '{{ .Values.components.monitoring.datadog.namespace }}' && object.metadata.labels['app.kubernetes.io/component']=='agent'"
{{- end }}


{{- if include "common.used" .Values.components.monitoring.k8sMonitoring }}
- apiVersion: policies.kyverno.io/v1
  kind: PolicyException
  metadata:
    name: k8s-monitoring-alloy-logs
    namespace: infra-kyverno
    annotations:
      helm.sh/resource-policy: keep
  spec:
    policyRefs:
      - name: disallow-capabilities
        kind: ValidatingPolicy
      - name: disallow-host-path
        kind: ValidatingPolicy
    matchConditions:
      - name: skip-by-name-and-namespace
        expression: "object.metadata.name.startsWith('k8s-monitoring-alloy-logs') && object.metadata.namespace == '{{ .Values.components.monitoring.k8sMonitoring.namespace }}'"
- apiVersion: policies.kyverno.io/v1
  kind: PolicyException
  metadata:
    name: k8s-monitoring-alloy-singleton
    namespace: infra-kyverno
    annotations:
      helm.sh/resource-policy: keep
  spec:
    policyRefs:
      - name: disallow-capabilities
        kind: ValidatingPolicy
    matchConditions:
      - name: skip-by-name-and-namespace
        expression: "object.metadata.name.startsWith('k8s-monitoring-alloy-singleton') && object.metadata.namespace == '{{ .Values.components.monitoring.k8sMonitoring.namespace }}'"
{{- end }}


{{- if eq .Values.cloudProvider "scw" }}
- apiVersion: policies.kyverno.io/v1
  kind: PolicyException
  metadata:
    name: scaleway-csi
    namespace: infra-kyverno
    annotations:
      helm.sh/resource-policy: keep
  spec:
    policyRefs:
      - name: disallow-capabilities
        kind: ValidatingPolicy
      - name: disallow-host-namespaces
        kind: ValidatingPolicy
      - name: disallow-host-path
        kind: ValidatingPolicy
      - name: disallow-privileged-containers
        kind: ValidatingPolicy
    matchConditions:
      - name: skip-by-name-and-namespace-and
        expression: "object.metadata.name.startsWith('csi-node') && object.metadata.namespace == 'kube-system'"
- apiVersion: policies.kyverno.io/v1
  kind: PolicyException
  metadata:
    name: scaleway-csi-filestorage
    namespace: infra-kyverno
    annotations:
      helm.sh/resource-policy: keep
  spec:
    policyRefs:
      - name: disallow-capabilities
        kind: ValidatingPolicy
      - name: disallow-host-namespaces
        kind: ValidatingPolicy
      - name: disallow-host-path
        kind: ValidatingPolicy
      - name: disallow-privileged-containers
        kind: ValidatingPolicy
    matchConditions:
      - name: skip-by-name-and-namespace-and
        expression: "object.metadata.name.startsWith('filestorage-csi-node') && object.metadata.namespace == 'kube-system'"
- apiVersion: policies.kyverno.io/v1
  kind: PolicyException
  metadata:
    name: scaleway-multipath-default-route
    namespace: infra-kyverno
    annotations:
      helm.sh/resource-policy: keep
  spec:
    policyRefs:
      - name: disallow-host-namespaces
        kind: ValidatingPolicy
      - name: disallow-privileged-containers
        kind: ValidatingPolicy
    matchConditions:
      - name: skip-by-name-and-namespace-and
        expression: "object.metadata.name.startsWith('multipath-default-route') && object.metadata.namespace == 'kube-system'"
{{- end }}


{{- if eq .Values.cloudProvider "scw" }}
- apiVersion: policies.kyverno.io/v1
  kind: PolicyException
  metadata:
    name: konnectivity-agent
    namespace: infra-kyverno
    annotations:
      helm.sh/resource-policy: keep
  spec:
    policyRefs:
      - name: disallow-host-namespaces
        kind: ValidatingPolicy
    matchConditions:
      - name: skip-by-name-and-namespace
        expression: "object.metadata.name.startsWith('konnectivity-agent') && object.metadata.namespace == 'kube-system'"
{{- end }}


{{- if eq .Values.kubernetesDistribution "k3s" }}
- apiVersion: policies.kyverno.io/v1
  kind: PolicyException
  metadata:
    name: k3s-svclb
    namespace: infra-kyverno
    annotations:
      helm.sh/resource-policy: keep
  spec:
    policyRefs:
      - name: disallow-capabilities
        kind: ValidatingPolicy
    matchConditions:
      - name: skip-by-name-and-namespace-and-component
        expression: "object.metadata.name.startsWith('svclb') && object.metadata.namespace == 'kube-system'"
- apiVersion: policies.kyverno.io/v1
  kind: PolicyException
  metadata:
    name: k3s-svclb-nginx
    namespace: infra-kyverno
    annotations:
      helm.sh/resource-policy: keep
  spec:
    policyRefs:
      - name: disallow-host-ports
        kind: ValidatingPolicy
      - name: restrict-sysctls
        kind: ValidatingPolicy
    matchConditions:
      - name: skip-by-name-and-namespace-and-component
        expression: "object.metadata.name.startsWith('svclb-nginx-ingress-ingress-nginx-controller') && object.metadata.namespace == 'kube-system'"
{{- end }}


{{- if include "common.used" .Values.components.security.trivy }}
- apiVersion: policies.kyverno.io/v1
  kind: PolicyException
  metadata:
    name: trivy-node-collector
    namespace: infra-kyverno
    annotations:
      helm.sh/resource-policy: keep
  spec:
    policyRefs:
      - name: disallow-host-namespaces
        kind: ValidatingPolicy
      - name: disallow-host-path
        kind: ValidatingPolicy
    matchConditions:
      - name: skip-by-name-and-namespace
        expression: "object.metadata.name.startsWith('node-collector') && object.metadata.namespace == '{{ .Values.components.security.trivy.namespace }}'"
{{- end }}


{{- if include "common.used" .Values.components.monitoring.kubePrometheusStack }}
- apiVersion: policies.kyverno.io/v1
  kind: PolicyException
  metadata:
    name: prometheus-node-exporter
    namespace: infra-kyverno
    annotations:
      helm.sh/resource-policy: keep
  spec:
    policyRefs:
      - name: disallow-host-namespaces
        kind: ValidatingPolicy
      - name: disallow-host-path
        kind: ValidatingPolicy
      - name: disallow-host-ports
        kind: ValidatingPolicy
    matchConditions:
      - name: skip-by-name-and-namespace
        expression: "object.metadata.name.startsWith('prometheus-prometheus-node-exporter') && object.metadata.namespace == '{{ .Values.components.monitoring.kubePrometheusStack.namespace }}'"
{{- end }}


{{- if include "common.used" .Values.components.monitoring.smartctlExporter }}
- apiVersion: policies.kyverno.io/v1
  kind: PolicyException
  metadata:
    name: prometheus-smartctl-exporter
    namespace: infra-kyverno
    annotations:
      helm.sh/resource-policy: keep
  spec:
    policyRefs:
      - name: disallow-privileged-containers
        kind: ValidatingPolicy
      - name: disallow-host-namespaces
        kind: ValidatingPolicy
      - name: disallow-host-path
        kind: ValidatingPolicy
    matchConditions:
      - name: skip-by-namespace
        expression: "object.metadata.namespace == '{{ .Values.components.monitoring.smartctlExporter.namespace }}'"
{{- end }}


{{- if include "common.used" .Values.components.security.falco }}
- apiVersion: policies.kyverno.io/v1
  kind: PolicyException
  metadata:
    name: falco
    namespace: infra-kyverno
    annotations:
      helm.sh/resource-policy: keep
  spec:
    policyRefs:
      - name: disallow-privileged-containers
        kind: ValidatingPolicy
      - name: disallow-host-namespaces
        kind: ValidatingPolicy
      - name: disallow-host-path
        kind: ValidatingPolicy
    matchConditions:
      - name: skip-by-namespace-and-app
        expression: "object.metadata.namespace == '{{ .Values.components.security.falco.namespace }}' && object.metadata.labels['app.kubernetes.io/name'] == 'falco'"
{{- end }}


{{- if include "common.used" .Values.components.backup.velero }}
- apiVersion: policies.kyverno.io/v1
  kind: PolicyException
  metadata:
    name: velero-node-agent
    namespace: infra-kyverno
    annotations:
      helm.sh/resource-policy: keep
  spec:
    policyRefs:
      - name: disallow-host-path
        kind: ValidatingPolicy
    matchConditions:
      - name: skip-by-name-and-namespace
        expression: "object.metadata.name.startsWith('node-agent') && object.metadata.namespace == '{{ .Values.components.backup.velero.namespace }}'"
{{- end }}


{{- if include "common.used" .Values.components.monitoring.promtail }}
- apiVersion: policies.kyverno.io/v1
  kind: PolicyException
  metadata:
    name: promtail
    namespace: infra-kyverno
    annotations:
      helm.sh/resource-policy: keep
  spec:
    policyRefs:
      - name: disallow-host-path
        kind: ValidatingPolicy
    matchConditions:
      - name: skip-by-name-and-namespace
        expression: "object.metadata.name.startsWith('promtail') && object.metadata.namespace == '{{ .Values.components.monitoring.promtail.namespace }}'"
{{- end }}


{{- if include "common.used" .Values.components.monitoring.x509CertificateExporter }}
- apiVersion: policies.kyverno.io/v1
  kind: PolicyException
  metadata:
    name: x509-certificate-exporter-nodes
    namespace: infra-kyverno
    annotations:
      helm.sh/resource-policy: keep
  spec:
    policyRefs:
      - name: disallow-host-path
        kind: ValidatingPolicy
    matchConditions:
      - name: skip-by-name-and-namespace
        expression: "object.metadata.name.startsWith('x509-x509-certificate-exporter') && object.metadata.namespace == '{{ .Values.components.monitoring.x509CertificateExporter.namespace }}'"
{{- end }}

{{- end }}


{{/* values */}}
{{- define "security.kyverno.policies.defaultValues" }}
{{- $me := .Values.components.security.kyverno }}
# default failurePolicy Fail will block is webhook made an error. Ignore will continue
failurePolicy: Ignore

# validationFailureAction : Audit or Enforce
validationFailureAction: Enforce

{{- if (semverCompare ">=3.7.0" $me.chart.version) }}

# ClusterPolicy is deprecated from Kyverno 1.17
policyType: ValidatingPolicy

customPolicies:
# default policies based on used components:
{{- template "security.kyverno.policies.defaultValues.policyExceptions" . }}
# and passed customPolicies from policiesValues:
{{-  with $me.policiesValues.customPolicies }}
{{ . | toYaml }}
{{- end }}


{{- else }}

policyType: ClusterPolicy
{{- template "security.kyverno.policies.mergedPolicyExclude" . }}

{{- end }}

{{- end }}


{{/* merged values : default + user  */}}
{{- define "security.kyverno.policies.mergedValues" }}
{{- $me := .Values.components.security.kyverno }}
{{- $defaultValues := include "security.kyverno.policies.defaultValues" . | fromYaml }}
{{- $customValues := $me.values | default dict }}
{{- merge (deepCopy $defaultValues) $customValues | toYaml }}
{{- end }}

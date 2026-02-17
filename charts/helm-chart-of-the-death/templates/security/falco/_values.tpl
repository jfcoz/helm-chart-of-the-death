{{/* values */}}
{{- define "security.falco.defaultValues.customRules" }}
{{- $me := .Values.components.security.falco }}
customRules:
  # les custom rules seront dans /etc/falco/rules.d/ et seront charges apres celles par default qu'elles peuvent donc patcher
  # CF : https://github.com/falcosecurity/charts/issues/788#issuecomment-2527646482
  default-rules-exclusions.yaml: |-

    # Macro k8s_containers:
    # fluxcd
    - macro: k8s_containers
      override:
        condition: append
      condition: |
        or (
          k8s.ns.name = "{{ .Values.components.gitops.fluxcd.namespace}}"
          and container.image.repository in (
            ghcr.io/fluxcd/helm-controller,
            ghcr.io/fluxcd/kustomize-controller,
            ghcr.io/fluxcd/notification-controller,
            ghcr.io/fluxcd/source-controller
          )
        )
    {{- if include "common.used" .Values.components.backup.velero }}
    - macro: k8s_containers
      override:
        condition: append
      condition: |
        or (
          k8s.ns.name = "{{ .Values.components.backup.velero.namespace}}"
          and container.image.repository in (
            docker.io/velero/velero
          )
        )
    {{- end }}
    {{- if include "common.used" .Values.components.monitoring.keda }}
    - macro: k8s_containers
      override:
        condition: append
      condition: |
        or (
          k8s.ns.name = "{{ .Values.components.monitoring.keda.namespace}}"
          and container.image.repository in (
            ghcr.io/kedacore/keda,
            ghcr.io/kedacore/keda-admission-webhooks,
            ghcr.io/kedacore/keda-metrics-apiserver
          )
        )
    {{- end }}
    {{- if include "common.used" .Values.components.monitoring.k8sMonitoring }}
    - macro: k8s_containers
      override:
        condition: append
      condition: |
        or (
          k8s.ns.name = "{{ .Values.components.monitoring.k8sMonitoring.namespace}}"
          and container.image.repository in (
            docker.io/grafana/alloy,
            docker.io/grafana/alloy-operator,
            ghcr.io/grafana/alloy-operator,
            ghcr.io/grafana/helm-chart-toolbox-kubectl
          )
        )
    {{- end }}
    {{- if include "common.used" .Values.components.monitoring.kubePrometheusStack }}
    - macro: k8s_containers
      override:
        condition: append
      condition: |
        or (
          k8s.ns.name = "{{ .Values.components.monitoring.kubePrometheusStack.namespace}}"
          and container.image.repository in (
            quay.io/kiwigrid/k8s-sidecar,
            quay.io/prometheus/prometheus,
            registry.k8s.io/kube-state-metrics/kube-state-metrics,
            ghcr.io/jkroepke/kube-webhook-certgen
          )
        )
    {{- end }}
    {{- if include "common.used" .Values.components.monitoring.openTelemetryOperator }}
    - macro: k8s_containers
      override:
        condition: append
      condition: |
        or (
          k8s.ns.name = "{{ .Values.components.monitoring.openTelemetryOperator.namespace}}"
          and container.image.repository in (
            ghcr.io/open-telemetry/opentelemetry-operator/opentelemetry-operator
          )
        )
    {{- end }}
    {{- if include "common.used" .Values.components.monitoring.promtail }}
    - macro: k8s_containers
      override:
        condition: append
      condition: |
        or (
          k8s.ns.name = "{{ .Values.components.monitoring.promtail.namespace}}"
          and container.image.repository in (
            grafana/promtail,
            docker.io/grafana/promtail
          )
        )
    {{- end }}
    {{- if include "common.used" .Values.components.monitoring.x509CertificateExporter }}
    - macro: k8s_containers
      override:
        condition: append
      condition: |
        or (
          k8s.ns.name = "{{ .Values.components.monitoring.x509CertificateExporter.namespace}}"
          and container.image.repository in (
            enix/x509-certificate-exporter,
            docker.io/enix/x509-certificate-exporter
          )
        )
    {{- end }}
    {{- if include "common.used" .Values.components.ingress.nginxIngressController }}
    - macro: k8s_containers
      override:
        condition: append
      condition: |
        or (
          k8s.ns.name = "{{ .Values.components.ingress.nginxIngressController.namespace}}"
          and container.image.repository in (
            registry.k8s.io/ingress-nginx/controller
          )
        )
    {{- end }}
    {{- if include "common.used" .Values.components.audit.popeye }}
    - macro: k8s_containers
      override:
        condition: append
      condition: |
        or (
          k8s.ns.name = "{{ .Values.components.audit.popeye.namespace}}"
          and container.image.repository in (
            ghcr.io/undistro/popeye
          )
        )
    {{- end }}
    {{- if include "common.used" .Values.components.database.cnpg }}
    - macro: k8s_containers
      override:
        condition: append
      condition: |
        or (
          k8s.ns.name = "{{ .Values.components.database.cnpg.namespace}}"
          and container.image.repository in (
            ghcr.io/cloudnative-pg/cloudnative-pg
          )
        )
    {{- end }}
    {{- if include "common.used" .Values.components.database.cnpgPluginBarmanCloud }}
    - macro: k8s_containers
      override:
        condition: append
      condition: |
        or (
          k8s.ns.name = "{{ .Values.components.database.cnpg.namespace}}"
          and container.image.repository in (
            ghcr.io/cloudnative-pg/plugin-barman-cloud
          )
        )
    {{- end }}
    {{- if include "common.used" .Values.components.security.certManager }}
    - macro: k8s_containers
      override:
        condition: append
      condition: |
        or (
          k8s.ns.name = "{{ .Values.components.security.certManager.namespace}}"
          and container.image.repository in (
            quay.io/jetstack/cert-manager-controller,
            quay.io/jetstack/cert-manager-webhook
          )
        )
    {{- end }}
    # condition not needed for ourself
    - macro: k8s_containers
      override:
        condition: append
      condition: |
        or (
          k8s.ns.name = "{{ .Values.components.security.falco.namespace}}"
          and container.image.repository in (
            falcosecurity/k8s-metacollector,
            docker.io/falcosecurity/k8s-metacollector
          )
        )
    {{- if include "common.used" .Values.components.security.kyverno }}
    - macro: k8s_containers
      override:
        condition: append
      condition: |
        or (
          k8s.ns.name = "{{ .Values.components.security.kyverno.namespace}}"
          and container.image.repository in (
            reg.kyverno.io/kyverno/kyverno,
            reg.kyverno.io/kyverno/cleanup-controller,
            reg.kyverno.io/kyverno/reports-controller,
            reg.kyverno.io/kyverno/background-controller 
          )
        )
    {{- end }}
    {{- if include "common.used" .Values.components.storage.rook }}
    - macro: k8s_containers
      override:
        condition: append
      condition: |
        or (
          k8s.ns.name = "{{ .Values.components.storage.rook.namespace }}"
          and container.image.repository in (
            quay.io/cephcsi/cephcsi,
            quay.io/cephcsi/ceph-csi-operator,
            registry.k8s.io/sig-storage/csi-snapshotter,
            registry.k8s.io/sig-storage/csi-attacher,
            registry.k8s.io/sig-storage/csi-provisioner,
            registry.k8s.io/sig-storage/csi-resizer
          )
        )
    {{- end }}



    # list allowed_container_images_loading_kernel_module
    {{- if include "common.used" .Values.components.storage.rook }}
    - list: allowed_container_images_loading_kernel_module
      override:
        items: append
      items:
        - quay.io/cephcsi/cephcsi
    {{- end }}


    {{- if include "common.used" .Values.components.database.cnpg }}
    - macro: postgres_running_cnpg
      condition: (proc.pname=postgres and (proc.cmdline startswith "sh -c /controller/manager wal-archive --log-destination /controller/log/postgres.json"))

    - rule: "Run shell untrusted"
      override:
        condition: append
      condition: |
        and not postgres_running_cnpg
    {{- end }}

{{- end }}

{{/* values */}}
{{- define "security.falco.defaultValues" }}
{{- $me := .Values.components.security.falco }}
podPriorityClassName: system-node-critical
tty: false
tolerations:
  - effect: NoSchedule
    key: master
    operator: Exists
  - effect: NoSchedule
    key: storage
    operator: Exists
resources:
  requests:
    cpu: 100m
    memory: 150M
falcoctl:
  artifact:
    install:
      resources:
        requests:
          memory: 35M
    follow:
      resources:
        requests:
          memory: 35M
          cpu: 1m
driver:
  loader:
    initContainer:
      resources:
        requests:
          memory: 35M
controller:
  daemonset:
    updateStrategy:
      rollingUpdate:
        maxUnavailable: 50%
collectors:
  kubernetes:
    enabled: true
  # with K3S : https://falco.org/docs/setup/enviroments/#k3s
  containerd:
    enabled: true
    socket: /run/k3s/containerd/containerd.sock
k8s-metacollector:
  resources:
    requests:
      memory: 50M
      cpu: 5m
falcosidekick:
  enabled: true
  resources:
    requests:
      memory: 70M
      cpu: 2m
  {{- if include "common.used" .Values.components.monitoring.datadog }}
  podAnnotations:
    # https://github.com/falcosecurity/falcosidekick/issues/526
    ad.datadoghq.com/falcosidekick.logs: >-
      [{
        "log_processing_rules": [
          {
            "type": "exclude_at_match",
            "name": "exclude_info_level",
            "pattern" : "[INFO]"
          }
        ]
      }]
  {{- end }}
  webui:
    enabled: true
    replicaCount: 1
    resources:
      requests:
        memory: 20M
        cpu: 2m
    initContainer:
      resources:
        requests:
          memory: 10M
    redis:
      resources:
        requests:
          memory: 300M
          cpu: 5m
        limits:
          memory: 300M
      customConfig:
        - maxmemory-policy allkeys-lfu
        - maxmemory 30mb
  config:
    customfields: "cluster_name:{{ .Values.global.clusterName | required "missing global.cluster_name" }}"
    alertmanager:
      hostport: {{ template "monitoring.kubePrometheusStack.alertManagerEndpoint" . }}
      minimumpriority: "notice"
      endpoint: "/api/v2/alerts"
    #slack:
    #  webhookurl: "https://hooks.slack.com/services/TODO"
    #  minimumpriority: "warning"
metrics:
  # -- enabled specifies whether the metrics should be enabled.
  enabled: true

serviceMonitor:
  # -- create specifies whether a ServiceMonitor CRD should be created for a prometheus operator.
  # https://github.com/coreos/prometheus-operator
  # Enable it only if the ServiceMonitor CRD is installed in your cluster.
  {{- if include "common.used" .Values.components.monitoring.kubePrometheusStack }}
  create: true
  {{- else }}
  create: false
  {{- end }}

{{- template "security.falco.defaultValues.customRules" . }}
{{- end }}


{{/* merged values : default + user  */}}
{{- define "security.falco.mergedValues" }}
{{- $me := .Values.components.security.falco }}
{{- $defaultValues := include "security.falco.defaultValues" . | fromYaml }}
{{- $customValues := $me.values | default dict }}
{{- mergeOverwrite $defaultValues $customValues | toYaml }}
{{- end }}

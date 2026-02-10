{{- define "monitoring.kubePrometheusStack.kubeStateMetrics.Flux.rbac" }}
# From https://raw.githubusercontent.com/fluxcd/flux2-monitoring-example/refs/heads/main/monitoring/controllers/kube-prometheus-stack/kube-state-metrics-config.yaml
- apiGroups:
  - source.toolkit.fluxcd.io
  - kustomize.toolkit.fluxcd.io
  - helm.toolkit.fluxcd.io
  - notification.toolkit.fluxcd.io
  - image.toolkit.fluxcd.io
  resources:
  - gitrepositories
  - buckets
  - helmrepositories
  - helmcharts
  - ocirepositories
  - kustomizations
  - helmreleases
  - alerts
  - providers
  - receivers
  - imagerepositories
  - imagepolicies
  - imageupdateautomations
  verbs: [ "list", "watch" ]
{{- end }}

{{- define "monitoring.kubePrometheusStack.kubeStateMetrics.Flux.customResourceState" }}
# From https://raw.githubusercontent.com/fluxcd/flux2-monitoring-example/refs/heads/main/monitoring/controllers/kube-prometheus-stack/kube-state-metrics-config.yaml
- groupVersionKind:
    group: kustomize.toolkit.fluxcd.io
    version: v1
    kind: Kustomization
  metricNamePrefix: gotk
  metrics:
    - name: "resource_info"
      help: "The current state of a Flux Kustomization resource."
      each:
        type: Info
        info:
          labelsFromPath:
            name: [ metadata, name ]
      labelsFromPath:
        exported_namespace: [ metadata, namespace ]
        ready: [ status, conditions, "[type=Ready]", status ]
        suspended: [ spec, suspend ]
        revision: [ status, lastAppliedRevision ]
        source_name: [ spec, sourceRef, name ]
- groupVersionKind:
    group: helm.toolkit.fluxcd.io
    version: v2
    kind: HelmRelease
  metricNamePrefix: gotk
  metrics:
    - name: "resource_info"
      help: "The current state of a Flux HelmRelease resource."
      each:
        type: Info
        info:
          labelsFromPath:
            name: [ metadata, name ]
      labelsFromPath:
        exported_namespace: [ metadata, namespace ]
        ready: [ status, conditions, "[type=Ready]", status ]
        suspended: [ spec, suspend ]
        revision: [ status, history, "0", chartVersion ]
        chart_name: [ status, history, "0", chartName ]
        chart_app_version: [ status, history, "0", appVersion ]
        chart_ref_name: [ spec, chartRef, name ]
        chart_source_name: [ spec, chart, spec, sourceRef, name ]
- groupVersionKind:
    group: source.toolkit.fluxcd.io
    version: v1
    kind: GitRepository
  metricNamePrefix: gotk
  metrics:
    - name: "resource_info"
      help: "The current state of a Flux GitRepository resource."
      each:
        type: Info
        info:
          labelsFromPath:
            name: [ metadata, name ]
      labelsFromPath:
        exported_namespace: [ metadata, namespace ]
        ready: [ status, conditions, "[type=Ready]", status ]
        suspended: [ spec, suspend ]
        revision: [ status, artifact, revision ]
        url: [ spec, url ]
- groupVersionKind:
    group: source.toolkit.fluxcd.io
    version: v1
    kind: Bucket
  metricNamePrefix: gotk
  metrics:
    - name: "resource_info"
      help: "The current state of a Flux Bucket resource."
      each:
        type: Info
        info:
          labelsFromPath:
            name: [ metadata, name ]
      labelsFromPath:
        exported_namespace: [ metadata, namespace ]
        ready: [ status, conditions, "[type=Ready]", status ]
        suspended: [ spec, suspend ]
        revision: [ status, artifact, revision ]
        endpoint: [ spec, endpoint ]
        bucket_name: [ spec, bucketName ]
- groupVersionKind:
    group: source.toolkit.fluxcd.io
    version: v1
    kind: HelmRepository
  metricNamePrefix: gotk
  metrics:
    - name: "resource_info"
      help: "The current state of a Flux HelmRepository resource."
      each:
        type: Info
        info:
          labelsFromPath:
            name: [ metadata, name ]
      labelsFromPath:
        exported_namespace: [ metadata, namespace ]
        ready: [ status, conditions, "[type=Ready]", status ]
        suspended: [ spec, suspend ]
        revision: [ status, artifact, revision ]
        url: [ spec, url ]
- groupVersionKind:
    group: source.toolkit.fluxcd.io
    version: v1
    kind: HelmChart
  metricNamePrefix: gotk
  metrics:
    - name: "resource_info"
      help: "The current state of a Flux HelmChart resource."
      each:
        type: Info
        info:
          labelsFromPath:
            name: [ metadata, name ]
      labelsFromPath:
        exported_namespace: [ metadata, namespace ]
        ready: [ status, conditions, "[type=Ready]", status ]
        suspended: [ spec, suspend ]
        revision: [ status, artifact, revision ]
        chart_name: [ spec, chart ]
        chart_version: [ spec, version ]
- groupVersionKind:
    group: source.toolkit.fluxcd.io
    version: v1
    kind: OCIRepository
  metricNamePrefix: gotk
  metrics:
    - name: "resource_info"
      help: "The current state of a Flux OCIRepository resource."
      each:
        type: Info
        info:
          labelsFromPath:
            name: [ metadata, name ]
      labelsFromPath:
        exported_namespace: [ metadata, namespace ]
        ready: [ status, conditions, "[type=Ready]", status ]
        suspended: [ spec, suspend ]
        revision: [ status, artifact, revision ]
        url: [ spec, url ]
- groupVersionKind:
    group: notification.toolkit.fluxcd.io
    version: v1beta3
    kind: Alert
  metricNamePrefix: gotk
  metrics:
    - name: "resource_info"
      help: "The current state of a Flux Alert resource."
      each:
        type: Info
        info:
          labelsFromPath:
            name: [ metadata, name ]
      labelsFromPath:
        exported_namespace: [ metadata, namespace ]
        suspended: [ spec, suspend ]
- groupVersionKind:
    group: notification.toolkit.fluxcd.io
    version: v1beta3
    kind: Provider
  metricNamePrefix: gotk
  metrics:
    - name: "resource_info"
      help: "The current state of a Flux Provider resource."
      each:
        type: Info
        info:
          labelsFromPath:
            name: [ metadata, name ]
      labelsFromPath:
        exported_namespace: [ metadata, namespace ]
        suspended: [ spec, suspend ]
- groupVersionKind:
    group: notification.toolkit.fluxcd.io
    version: v1
    kind: Receiver
  metricNamePrefix: gotk
  metrics:
    - name: "resource_info"
      help: "The current state of a Flux Receiver resource."
      each:
        type: Info
        info:
          labelsFromPath:
            name: [ metadata, name ]
      labelsFromPath:
        exported_namespace: [ metadata, namespace ]
        ready: [ status, conditions, "[type=Ready]", status ]
        suspended: [ spec, suspend ]
        webhook_path: [ status, webhookPath ]
- groupVersionKind:
    group: image.toolkit.fluxcd.io
    version: v1
    kind: ImageRepository
  metricNamePrefix: gotk
  metrics:
    - name: "resource_info"
      help: "The current state of a Flux ImageRepository resource."
      each:
        type: Info
        info:
          labelsFromPath:
            name: [ metadata, name ]
      labelsFromPath:
        exported_namespace: [ metadata, namespace ]
        ready: [ status, conditions, "[type=Ready]", status ]
        suspended: [ spec, suspend ]
        image: [ spec, image ]
- groupVersionKind:
    group: image.toolkit.fluxcd.io
    version: v1
    kind: ImagePolicy
  metricNamePrefix: gotk
  metrics:
    - name: "resource_info"
      help: "The current state of a Flux ImagePolicy resource."
      each:
        type: Info
        info:
          labelsFromPath:
            name: [ metadata, name ]
      labelsFromPath:
        exported_namespace: [ metadata, namespace ]
        ready: [ status, conditions, "[type=Ready]", status ]
        suspended: [ spec, suspend ]
        source_name: [ spec, imageRepositoryRef, name ]
- groupVersionKind:
    group: image.toolkit.fluxcd.io
    version: v1
    kind: ImageUpdateAutomation
  metricNamePrefix: gotk
  metrics:
    - name: "resource_info"
      help: "The current state of a Flux ImageUpdateAutomation resource."
      each:
        type: Info
        info:
          labelsFromPath:
            name: [ metadata, name ]
      labelsFromPath:
        exported_namespace: [ metadata, namespace ]
        ready: [ status, conditions, "[type=Ready]", status ]
        suspended: [ spec, suspend ]
        source_name: [ spec, sourceRef, name ]
{{- end }}

{{/* values */}}
{{- define "monitoring.kubePrometheusStack.defaultValues" }}
grafana:
  adminPassword: {{ .Values.global.grafanaAdminPassword | required "global.grafanaAdminPassword is mandatory" | quote }}
  grafana.ini:
    server:
      root_url: "https://grafana.{{ .Values.global.ingressWildcardSuffix }}"
    database:
      # Workaround for database is locked error:  https://github.com/grafana/grafana/issues/65115
      wal: true
    #log:
    #  level: debug
    #log.console:
    #  level: debug
    #dataproxy:
    #  logging: true
  persistence:
    enabled: true
    storageClassName: ceph-block
    size: 1Gi
  deploymentStrategy:
    # Needed with ReadWriteOnce
    type: Recreate
  additionalDataSources:
    {{- if include "common.used" .Values.components.monitoring.loki }}
    - name: Loki
      type: loki
      access: proxy
      url: {{ template "monitoring.loki.readEndpoint" . }}
    {{- end }}
    - name: alertmanager
      type: alertmanager
      access: proxy
      url: http://{{ "{{" }} template "kube-prometheus-stack.fullname" . }}-alertmanager:9093
      jsonData:
        implementation: prometheus
    {{- if include "common.used" .Values.components.monitoring.tempo }}
    - name: tempo
      type: tempo
      access: proxy
      url: {{ template "monitoring.tempo.queryEndpoint" . }}
      jsonData:
        # https://grafana.com/docs/grafana/latest/datasources/tempo/configure-tempo-data-source/#provision-the-data-source
        serviceMap:
          datasourceUid: 'prometheus'
        nodeGraph:
          enabled: true
        tracesToLogsV2:
          datasourceUid: 'loki'
        tracesToMetrics:
          datasourceUid: 'prometheus'
    {{- end }}
    {{- if include "common.used" .Values.components.monitoring.thanos }}
    - name: thanos
      type: prometheus
      access: proxy
      url: {{ template "monitoring.thanos.endpoint" . }}
    {{- end }}
  ingress:
    enabled: true
    ingressClassName: nginx
    hosts:
      - grafana.{{ .Values.global.ingressWildcardSuffix }}
    annotations:
      cert-manager.io/cluster-issuer: letsencrypt-production
    tls:
    - secretName: grafana-general-tls
      hosts:
        - grafana.{{ .Values.global.ingressWildcardSuffix }}
  dashboardProviders:
    dashboardproviders.yaml:
      apiVersion: 1
      providers:
      - name: 'default'
        orgId: 1
        folder: ''
        type: file
        disableDeletion: true
        editable: false
        options:
          path: /var/lib/grafana/dashboards/default
      - name: fluxcd
        orgId: 1
        folder: 'FluxCD'
        type: file
        disableDeletion: true
        editable: false
        options:
          path: /var/lib/grafana/dashboards/fluxcd
      {{- if include "common.used" .Values.components.monitoring.x509CertificateExporter }}
      - name: 'x509-certificate-exporter'
        orgId: 1
        folder: 'X509 certificate exporter'
        type: file
        disableDeletion: true
        editable: false
        options:
          path: /var/lib/grafana/dashboards/x509-certificate-exporter
      {{- end }}
      {{- if include "common.used" .Values.components.security.falco }}
      - name: 'falco'
        orgId: 1
        folder: 'Falco'
        type: file
        disableDeletion: true
        editable: false
        options:
          path: /var/lib/grafana/dashboards/falco
      {{- end }}
      {{- if include "common.used" .Values.components.storage.rook }}
      - name: 'ceph'
        orgId: 1
        folder: 'Ceph'
        type: file
        disableDeletion: true
        editable: false
        options:
          path: /var/lib/grafana/dashboards/ceph
      {{- end }}
      {{- if include "common.used" .Values.components.security.trivy }}
      - name: 'trivy'
        orgId: 1
        folder: 'Trivy'
        type: file
        disableDeletion: true
        editable: false
        options:
          path: /var/lib/grafana/dashboards/trivy
      {{- end }}
  dashboards:
    fluxcd:
      cluster:
        url: https://raw.githubusercontent.com/fluxcd/flux2-monitoring-example/refs/heads/main/monitoring/configs/dashboards/cluster.json
        datasource: Prometheus
      control-plane:
        url: https://raw.githubusercontent.com/fluxcd/flux2-monitoring-example/refs/heads/main/monitoring/configs/dashboards/control-plane.json
        datasource: Prometheus
      {{- if include "common.used" .Values.components.monitoring.loki }}
      logs:
        url: https://raw.githubusercontent.com/fluxcd/flux2-monitoring-example/refs/heads/main/monitoring/configs/dashboards/logs.json
        datasource: Loki
      {{- end }}
    {{- if include "common.used" .Values.components.security.falco }}
    falco:
      falco-dashboard:
        url: https://raw.githubusercontent.com/falcosecurity/charts/refs/heads/master/charts/falco/dashboards/falco-dashboard.json
        datasource: Prometheus
    {{- end }}
    {{- if include "common.used" .Values.components.storage.rook }}
    ceph:
      ceph-application-overview:
        url: https://raw.githubusercontent.com/ceph/ceph/main/monitoring/ceph-mixin/dashboards_out/ceph-application-overview.json
        datasource: Prometheus
      ceph-cluster-advanced:
        url: https://raw.githubusercontent.com/ceph/ceph/main/monitoring/ceph-mixin/dashboards_out/ceph-cluster-advanced.json
        datasource: Prometheus
      ceph-cluster:
        url: https://raw.githubusercontent.com/ceph/ceph/main/monitoring/ceph-mixin/dashboards_out/ceph-cluster.json
        datasource: Prometheus
      host-details:
        url: https://raw.githubusercontent.com/ceph/ceph/main/monitoring/ceph-mixin/dashboards_out/host-details.json
        datasource: Prometheus
      hosts-overview:
        url: https://raw.githubusercontent.com/ceph/ceph/main/monitoring/ceph-mixin/dashboards_out/hosts-overview.json
        datasource: Prometheus
      osd-device-details:
        url: https://raw.githubusercontent.com/ceph/ceph/main/monitoring/ceph-mixin/dashboards_out/osd-device-details.json
        datasource: Prometheus
      osds-overview:
        url: https://raw.githubusercontent.com/ceph/ceph/main/monitoring/ceph-mixin/dashboards_out/osds-overview.json
        datasource: Prometheus
      pool-detail:
        url: https://raw.githubusercontent.com/ceph/ceph/main/monitoring/ceph-mixin/dashboards_out/pool-detail.json
        datasource: Prometheus
      pool-overview:
        url: https://raw.githubusercontent.com/ceph/ceph/main/monitoring/ceph-mixin/dashboards_out/pool-overview.json
        datasource: Prometheus
      radosgw-detail:
        url: https://raw.githubusercontent.com/ceph/ceph/main/monitoring/ceph-mixin/dashboards_out/radosgw-detail.json
        datasource: Prometheus
      radosgw-overview:
        url: https://raw.githubusercontent.com/ceph/ceph/main/monitoring/ceph-mixin/dashboards_out/radosgw-overview.json
        datasource: Prometheus
      radosgw-sync-overview:
        url: https://raw.githubusercontent.com/ceph/ceph/main/monitoring/ceph-mixin/dashboards_out/radosgw-sync-overview.json
        datasource: Prometheus
      rbd-details:
        url: https://raw.githubusercontent.com/ceph/ceph/main/monitoring/ceph-mixin/dashboards_out/rbd-details.json
        datasource: Prometheus
      rbd-overview:
        url: https://raw.githubusercontent.com/ceph/ceph/main/monitoring/ceph-mixin/dashboards_out/rbd-overview.json
        datasource: Prometheus
    {{- end }}
    {{- if include "common.used" .Values.components.monitoring.x509CertificateExporter }}
    x509-certificate-exporter:
      x509-certificate-exporter:
        gnetId: 13922
        revision: 3
        datasource: Prometheus
    {{- end }}
    {{- if include "common.used" .Values.components.security.trivy }}
    trivy:
      trivy-image-scan:
        url: https://raw.githubusercontent.com/jfcoz/grafana-config/main/dashboards/trivy_image_scan.json
        datasource: Prometheus
    {{- end }}
    default:
      # TODO subfolders
      ethtool:
        url: https://raw.githubusercontent.com/jfcoz/grafana-config/main/dashboards/ethtool.json
        datasource: Prometheus
      varnish-kube-httpcache:
        url: https://raw.githubusercontent.com/jfcoz/grafana-config/main/dashboards/varnish_kube_httpcache.json
        datasource: Prometheus
      kubernetes-compute-resources-cluster-capacity:
        url: https://raw.githubusercontent.com/jfcoz/grafana-config/main/dashboards/kubernetes_compute_resources_cluster_capacity.json
        datasource: Prometheus
      {{- if include "common.used" .Values.components.security.kyverno }}
      kyverno:
        url: https://raw.githubusercontent.com/kyverno/kyverno/main/charts/kyverno/charts/grafana/dashboard/kyverno-dashboard.json
        datasource: Prometheus
      {{- end }}
      blackbox-exporter:
        gnetId: 7587
        revision: 3
        datasource: Prometheus
      node-exporter-full:
        gnetId: 1860
        revision: 29
        datasource: Prometheus
      {{- if include "common.used" .Values.components.backup.velero }}
      kubernetes-velero:
        gnetId: 11055
        revision: 2
        datasource: Prometheus
      {{- end }}
      nginx-ingress:
        url: https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/grafana/dashboards/nginx.json
      {{- if include "common.used" .Values.components.audit.popeye }}
      popeye:
        #WIP
        #url: https://raw.githubusercontent.com/derailed/popeye/master/grafana/PopDash.json
        url: https://raw.githubusercontent.com/jfcoz/popeye/grafana-dashboard/grafana/popeye-dashboard.json
        datasource:
        - name: DS_PROMETHEUS
          value: Prometheus
      {{- end }}
  plugins:
    - grafana-piechart-panel
  resources:
    requests:
      memory: 150Mi
  sidecar:
    resources:
      requests:
        memory: 80Mi
prometheus:
  thanosService:
    enabled: {{ include "common.used" .Values.components.monitoring.thanos }}
  thanosServiceMonitor:
    enabled: true
  prometheusSpec:
    maximumStartupDurationSeconds: 900
    enableRemoteWriteReceiver: true
    serviceMonitorSelectorNilUsesHelmValues: false
    podMonitorSelectorNilUsesHelmValues: false
    probeSelectorNilUsesHelmValues: false
    ruleSelectorNilUsesHelmValues: false
    externalLabels:
      cluster: {{ .Values.global.clusterName | default "Required global.clusterName" }}
    # ne marche pas, liens vers oncall mieux mais faux, et grafana ne peux plus afficher le detail des alertes
    #externalUrl: https://grafana.{{ .Values.global.ingressWildcardSuffix }}
    replicas: 1
    resources:
      requests:
        cpu: 800m
        memory: 3Gi
      limits:
        memory: 3Gi
    storageSpec:
      volumeClaimTemplate:
        spec:
          storageClassName: ceph-block
          #storageClassName: longhorn 
          accessModes: ["ReadWriteOnce"]
          resources:
            requests:
              storage: 20Gi
    topologySpreadConstraints:
    - maxSkew: 1
      topologyKey: topology.kubernetes.io/zone
      whenUnsatisfiable: DoNotSchedule
      labelSelector:
        matchLabels:
          app: prometheus
    {{- if include "common.used" .Values.components.monitoring.thanos }}
    thanos:
      # https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/api.md#monitoring.coreos.com/v1.ThanosSpec
      objectStorageConfig:
        secret:
          type: S3
          config:
            bucket: thanos-bucket
            bucket_lookup_type: path
            endpoint: rook-ceph-rgw-ceph-objectstore.rook-ceph.svc
            region: rook
            access_key: '{{ "{{" }} (((lookup "v1" "Secret" "{{ .Values.components.monitoring.thanos.namespace }}" "thanos-bucket").data).AWS_ACCESS_KEY_ID) | default "bucket secret is not yet available" | b64dec }}'
            secret_key: '{{ "{{" }} (((lookup "v1" "Secret" "{{ .Values.components.monitoring.thanos.namespace }}" "thanos-bucket").data).AWS_SECRET_ACCESS_KEY) | default "bucket secret is not yet available" | b64dec }}'
            insecure: true
    {{- end }}
prometheus-node-exporter:
  resources:
    requests:
      memory: 25M
      cpu: 20m
  extraArgs:
    # default from https://github.com/prometheus-community/helm-charts/blob/main/charts/kube-prometheus-stack/values.yaml#L2474
    - --collector.filesystem.mount-points-exclude=^/(dev|proc|sys|var/lib/docker/.+|var/lib/kubelet/.+)($|/)
    - --collector.filesystem.fs-types-exclude=^(autofs|binfmt_misc|bpf|cgroup2?|configfs|debugfs|devpts|devtmpfs|fusectl|hugetlbfs|iso9660|mqueue|nsfs|overlay|proc|procfs|pstore|rpc_pipefs|securityfs|selinuxfs|squashfs|sysfs|tracefs)$
    # and custom
    - --collector.ethtool
    - --collector.ethtool.device-exclude="^(brq|tap|veth|vxlan|virbr|usb).*$"
prometheusOperator:
  resources:
    limits:
      cpu: 1000m
      memory: 400Mi
    requests:
      cpu: 0m
      memory: 40Mi
  prometheusConfigReloader:
    resources:
      limits:
        cpu: 500m
        memory: 50Mi
      requests:
        cpu: 1m
        memory: 30Mi
alertmanager:
  alertmanagerSpec:
    replicas: 2
    topologySpreadConstraints:
    - maxSkew: 1
      topologyKey: topology.kubernetes.io/zone
      whenUnsatisfiable: DoNotSchedule
      labelSelector:
        matchLabels:
          app: alertmanager
    resources:
      requests:
        memory: 80M
        cpu: 20m
    storage:
      volumeClaimTemplate:
        spec:
          storageClassName: ceph-block
          accessModes: ["ReadWriteOnce"]
          resources:
            requests:
              storage: 2Gi
  ## disabled : currently no auth
  # see https://github.com/prometheus-community/helm-charts/issues/1754
  #ingress:
  #  enabled: true
  #  ingressClassName: nginx
  #  hosts:
  #    - alertmanager.{{ .Values.global.ingressWildcardSuffix }}
  #  annotations:
  #    cert-manager.io/cluster-issuer: letsencrypt-production
  #  tls:
  #  - secretName: alertmanager-general-tls
  #    hosts:
  #      - alertmanager.{{ .Values.global.ingressWildcardSuffix }}
  config:
    inhibit_rules:
    - equal:
      - namespace
      - alertname
      source_matchers:
      - "severity = critical"
      target_matchers:
      - "severity =~ warning|info"
    - equal:
      - namespace
      - alertname
      source_matchers:
      - "severity = warning"
      target_matchers:
      - "severity = info"
    - equal:
      - namespace
      source_matchers:
      - "alertname = InfoInhibitor"
      target_matchers:
      - "severity = info"
    route:
      group_by:
      - namespace
      # default receiver
      #receiver: Slack
      receiver: 'null'
      routes:
      - matchers:
        - alertname = "InfoInhibitor"
        receiver: 'null'
      - matchers:
        - alertname = "Watchdog"
        receiver: Watchdog
        repeat_interval: 1m
        group_wait: 0s
        group_interval: 1m
      - matchers:
        - severity =~ "warning|info"
        receiver: 'null'
      - matchers:
        - severity = "critical"
        receiver: OnCall
    receivers:
      - name: 'null'
      - name: Slack
        slack_configs:
          - api_url: {{ .Values.alerts.alertmanager_slack_webhook | required "missing alerts.alertmanager_slack_webhook" }}
            send_resolved: true
      - name: Watchdog
        webhook_configs:
          - url: {{ .Values.alerts.alertmanager_watchdog_webhook | required "missing alerts.alertmanager_watchdog_webhook" }}
      - name: OnCall
        webhook_configs:
          - url: {{ .Values.alerts.alertmanager_oncall_webhook | required "missing alerts.alertmanager_oncall_webhook" }}
            send_resolved: true
kubeControllerManager:
  enabled: false
kube-state-metrics:
  metricLabelsAllowlist:
    - nodes=[topology.kubernetes.io/region,topology.kubernetes.io/zone]
  replicas: 2
  resources:
    requests:
      memory: 150Mi
      cpu: 30m
    limits:
      memory: 200Mi
  rbac:
    extraRules:
      {{- include "monitoring.kubePrometheusStack.kubeStateMetrics.Flux.rbac" . | nindent 6 }}
  customResourceState:
    enabled: true
    config:
      spec:
        resources:
          {{- include "monitoring.kubePrometheusStack.kubeStateMetrics.Flux.customResourceState" . | nindent 10 }}
defaultRules:
  rules:
    # TODO: kubernetesDistribution condition
    kubeProxy: false
    kubeSchedulerAlerting: false
    kubeSchedulerRecording: false
# custom Rules to override "for" and "severity" in defaultRules
customRules:
  # TODO: cluster-autoscaler condition
  # unneeded when cluster-autoscaler is used
  KubeMemoryOvercommit:
    severity: info
  KubeCPUOvercommit:
    severity: info

additionalPrometheusRulesMap: 
  rule-name:
    groups:
      # From https://fluxcd.io/docs/guides/monitoring/#metrics
      - name: Flux
        rules:
          #- alert: ReconciliationFailure
          #  expr: sum by(kind,name) (gotk_reconcile_condition{status="False",type="Ready"}) > 0
          #  for: 10m
          #  labels:
          #    severity: critical
          #  annotations:
          #    summary: '{{ "{{" }} $labels.kind }} {{ "{{" }} $labels.name }} reconciliation has been failing for more than ten minutes.'

          # From https://raw.githubusercontent.com/cozystack/cozystack/cad9cdedf5be97904e778629ccaafb590c9d7d4e/packages/system/monitoring/alerts/flux.yaml

          - alert: HelmReleaseNotReady
            expr: gotk_resource_info{customresource_kind="HelmRelease", ready!="True"} > 0
            for: 5m
            labels:
              severity: critical
              service: fluxcd
              exported_instance: '{{ "{{" }} $labels.exported_namespace }}/{{ "{{" }} $labels.name }}'
            annotations:
              summary: "HelmRelease {{ "{{" }} $labels.name }} in namespace {{ "{{" }} $labels.exported_namespace }} is not ready"
              description: "HelmRelease {{ "{{" }} $labels.name }} in namespace {{ "{{" }} $labels.exported_namespace }} is in an unready state for more than 15 minutes."
          - alert: GitRepositorySyncFailed
            expr: gotk_resource_info{customresource_kind="GitRepository", ready!="True"} > 0
            for: 5m
            labels:
              severity: warning
              service: fluxcd
              exported_instance: '{{ "{{" }} $labels.exported_namespace }}/{{ "{{" }} $labels.name }}'
            annotations:
              summary: "GitRepository {{ "{{" }} $labels.name }} in namespace {{ "{{" }} $labels.exported_namespace }} sync failed"
              description: "GitRepository {{ "{{" }} $labels.name }} in namespace {{ "{{" }} $labels.exported_namespace }} has not been successfully synced for more than 15 minutes."
          - alert: KustomizationNotApplied
            expr: gotk_resource_info{customresource_kind="Kustomization", ready!="True"} > 0
            for: 5m
            labels:
              severity: critical
              service: fluxcd
              exported_instance: '{{ "{{" }} $labels.exported_namespace }}/{{ "{{" }} $labels.name }}'
            annotations:
              summary: "Kustomization {{ "{{" }} $labels.name }} in namespace {{ "{{" }} $labels.exported_namespace }} is not applied"
              description: "Kustomization {{ "{{" }} $labels.name }} in namespace {{ "{{" }} $labels.exported_namespace }} is not successfully applied for more than 15 minutes."
          - alert: ImageRepositorySyncFailed
            expr: gotk_resource_info{customresource_kind="ImageRepository", ready!="True"} > 0
            for: 5m
            labels:
              severity: warning
              service: fluxcd
              exported_instance: '{{ "{{" }} $labels.exported_namespace }}/{{ "{{" }} $labels.name }}'
            annotations:
              summary: "ImageRepository {{ "{{" }} $labels.name }} in namespace {{ "{{" }} $labels.exported_namespace }} sync failed"
              description: "ImageRepository {{ "{{" }} $labels.name }} in namespace {{ "{{" }} $labels.exported_namespace }} has not been successfully synced for more than 15 minutes."
          - alert: HelmChartFailed
            expr: gotk_resource_info{customresource_kind="HelmChart", ready!="True"} > 0
            for: 5m
            labels:
              severity: warning
              service: fluxcd
              exported_instance: '{{ "{{" }} $labels.exported_namespace }}/{{ "{{" }} $labels.name }}'
            annotations:
              summary: "HelmChart {{ "{{" }} $labels.name }} in namespace {{ "{{" }} $labels.exported_namespace }} has failed"
              description: "HelmChart {{ "{{" }} $labels.name }} in namespace {{ "{{" }} $labels.exported_namespace }} is not ready for more than 15 minutes."
          - alert: HelmReleaseSuspended
            expr: gotk_resource_info{customresource_kind="HelmRelease", suspended="true"} > 0
            for: 5m
            labels:
              severity: warning
              service: fluxcd
              exported_instance: '{{ "{{" }} $labels.exported_namespace }}/{{ "{{" }} $labels.name }}'
            annotations:
              summary: "HelmRelease {{ "{{" }} $labels.name }} in namespace {{ "{{" }} $labels.exported_namespace }} is suspended"
              description: "HelmRelease {{ "{{" }} $labels.name }} in namespace {{ "{{" }} $labels.exported_namespace }} has been suspended."
          - alert: GitRepositorySuspended
            expr: gotk_resource_info{customresource_kind="GitRepository", suspended="true"} > 0
            for: 5m
            labels:
              severity: warning
              service: fluxcd
              exported_instance: '{{ "{{" }} $labels.exported_namespace }}/{{ "{{" }} $labels.name }}'
            annotations:
              summary: "GitRepository {{ "{{" }} $labels.name }} in namespace {{ "{{" }} $labels.exported_namespace }} is suspended"
              description: "GitRepository {{ "{{" }} $labels.name }} in namespace {{ "{{" }} $labels.exported_namespace }} has been suspended."
          - alert: KustomizationSuspended
            expr: gotk_resource_info{customresource_kind="Kustomization", suspended="true"} > 0
            for: 5m
            labels:
              severity: warning
              service: fluxcd
              exported_instance: '{{ "{{" }} $labels.exported_namespace }}/{{ "{{" }} $labels.name }}'
            annotations:
              summary: "Kustomization {{ "{{" }} $labels.name }} in namespace {{ "{{" }} $labels.exported_namespace }} is suspended"
              description: "Kustomization {{ "{{" }} $labels.name }} in namespace {{ "{{" }} $labels.exported_namespace }} has been suspended."
          - alert: ImageRepositorySuspended
            expr: gotk_resource_info{customresource_kind="ImageRepository", suspended="true"} > 0
            for: 5m
            labels:
              severity: warning
              service: fluxcd
              exported_instance: '{{ "{{" }} $labels.exported_namespace }}/{{ "{{" }} $labels.name }}'
            annotations:
              summary: "ImageRepository {{ "{{" }} $labels.name }} in namespace {{ "{{" }} $labels.exported_namespace }} is suspended"
              description: "ImageRepository {{ "{{" }} $labels.name }} in namespace {{ "{{" }} $labels.exported_namespace }} has been suspended."
          - alert: HelmChartSuspended
            expr: gotk_resource_info{customresource_kind="HelmChart", suspended="true"} > 0
            for: 5m
            labels:
              severity: warning
              service: fluxcd
              exported_instance: '{{ "{{" }} $labels.exported_namespace }}/{{ "{{" }} $labels.name }}'
            annotations:
              summary: "HelmChart {{ "{{" }} $labels.name }} in namespace {{ "{{" }} $labels.exported_namespace }} is suspended"
              description: "HelmChart {{ "{{" }} $labels.name }} in namespace {{ "{{" }} $labels.exported_namespace }} has been suspended."
      {{- if include "common.used" .Values.components.security.trivy }}
      - name: Trivy
        rules:
          - alert: ImageScanJobBlocked
            expr: sum by(job_name) (kube_job_complete{namespace="infra-trivy"})
            for: 5m
            labels:
              severity: critical
            annotations:
              summary: '{{ "{{" }} $labels.job_name }} image scan job is finished but not removed after more than five minutes.'
      {{- end }}
      - name: Nodes
        rules:
          - record: node:load1_per_cpu_ratio
            expr: |-
              avg by(node) (
                  avg by(internal_ip) (
                      label_replace(
                          avg by(instance) (instance:node_load1_per_cpu:ratio),
                          "internal_ip",
                          "$1",
                          "instance",
                          "([^:]+):.*"
                      )
                  )
                  * on(internal_ip) group_right
                  kube_node_info
              )

          - alert: NodeLoadHigh5m
            expr: |-
              avg by(node) (
                  node:load1_per_cpu_ratio
              ) > 16
            for: 5m
            labels:
              severity: critical
            annotations:
              summary: 'Load per core > 16 for 5m on {{ "{{" }} $labels.node }}'
              description: "The load average on node {{ "{{" }} $labels.node }} is too high since too long"
          - alert: NodeLoadHigh15m
            expr: |-
              avg by(node) (
                  node:load1_per_cpu_ratio
              ) > 8
            for: 15m
            labels:
              severity: critical
            annotations:
              summary: 'Load per core > 8 for 15m on {{ "{{" }} $labels.node }}'
              description: "The load average on node {{ "{{" }} $labels.node }} is too high since too long"
          - alert: NodeLoadHigh30m
            expr: |-
              avg by(node) (
                  node:load1_per_cpu_ratio
              ) > 4
            for: 30m
            labels:
              severity: critical
            annotations:
              summary: 'Load per core > 4 for 30m on {{ "{{" }} $labels.node }}'
              description: "The load average on node {{ "{{" }} $labels.node }} is too high since too long"
          - alert: NodeLoadHigh120m
            expr: |-
              avg by(node) (
                  node:load1_per_cpu_ratio
              ) > 1
            for: 120m
            labels:
              severity: warning
            annotations:
              summary: 'Load per core > 1 for 120m on {{ "{{" }} $labels.node }}'
              description: "The load average on node {{ "{{" }} $labels.node }} is too high since too long"
          - alert: NodeMemoryHigh
            expr: |-
              avg by(node) (
                  avg by(internal_ip) (
                      label_replace(
                          avg by(instance) (
                              (node_memory_MemFree_bytes + node_memory_Cached_bytes) / node_memory_MemTotal_bytes
                          ),
                          "internal_ip",
                          "$1",
                          "instance",
                          "([^:]+):.*"
                      )
                  )
                  * on(internal_ip) group_right
                  kube_node_info
              )
              < 0.1
            for: 3m
            labels:
              severity: critical
            annotations:
              summary: 'Memory high on {{ "{{" }} $labels.node }}'
              description: "The memory usage on node {{ "{{" }} $labels.node }} is too high. Free+cache is less than 10%"
          - alert: NodeReboot
            expr: |-
              avg by(node) (
                  avg by(internal_ip) (
                      label_replace(
                          avg by(instance) (
                              (node_time_seconds{} - node_boot_time_seconds{})
                          ),
                          "internal_ip",
                          "$1",
                          "instance",
                          "([^:]+):.*"
                      )
                  )
                  * on(internal_ip) group_right
                  kube_node_info
              )
              < 3600
            for: 3m
            labels:
              severity: critical
            annotations:
              summary: 'Node {{ "{{" }} $labels.node }} has rebooted'
              description: "Node uptime on {{ "{{" }} $labels.node }} is less than one hour. Investigate reboot reason"
          - alert: CpuTemperatureWarning
            expr: |-
              avg by(node) (
                  avg by(internal_ip) (
                      label_replace(
                          avg by(instance) (
                              (node_hwmon_temp_celsius{} / node_hwmon_temp_crit_celsius{})
                          ),
                          "internal_ip",
                          "$1",
                          "instance",
                          "([^:]+):.*"
                      )
                  )
                  * on(internal_ip) group_right
                  kube_node_info
              )
              > 0.8
            for: 3m
            labels:
              severity: warning
            annotations:
              summary: 'Node CPU temperature warning on{{ "{{" }} $labels.node }}'
              description: "Node CPU temperature on {{ "{{" }} $labels.node }} is more than 80% of limit"
          - alert: CpuTemperatureCritical
            expr: |-
              avg by(node) (
                  avg by(internal_ip) (
                      label_replace(
                          avg by(instance) (
                              (node_hwmon_temp_celsius{} / node_hwmon_temp_crit_celsius{})
                          ),
                          "internal_ip",
                          "$1",
                          "instance",
                          "([^:]+):.*"
                      )
                  )
                  * on(internal_ip) group_right
                  kube_node_info
              )
              > 0.9
            for: 1m
            labels:
              severity: critical
            annotations:
              summary: 'Node CPU temperature warning on{{ "{{" }} $labels.node }}'
              description: "Node CPU temperature on {{ "{{" }} $labels.node }} is more than 90% of limit"
      - name: Resources
        rules:
          - alert: MemoryWorkingSetOverRequest
            expr: |-
              (
                sum by(container, namespace, pod) (container_memory_working_set_bytes)
                /
                sum by(container, namespace, pod) (kube_pod_container_resource_requests{resource="memory"})
              ) > 1
            for: 30m
            labels:
              severity: warning
            annotations:
              summary: 'Memory working set vs request is too high'
              description: 'container {{ "{{" }} $labels.container }} of pod {{ "{{" }} $labels.pod }} in namespace{{ "{{" }} $labels.namespace }} have a memory working set (resident size, mapped files) upper to its memory request for too long. Please increase the memory request to avoir OOm killer in case of memory contention'
          - alert: MemoryRssOverRequest
            expr: |-
              (
                  sum by (namespace,pod,container) (kube_pod_container_resource_requests{resource="memory"})
                  -
                  sum by (namespace,pod,container) (container_memory_working_set_bytes{container!=""})
                  > 50*1024*1024
              )
              and
              (
                  sum by (namespace,pod,container) (kube_pod_container_resource_requests{resource="memory"})
                  /
                  sum by (namespace,pod,container) (container_memory_working_set_bytes{container!=""})
                  > 2
              )
            for: 24h
            labels:
              severity: warning
            annotations:
              summary: 'Memory usage vs request is too high'
              description: 'container {{ "{{" }} $labels.container }} of pod {{ "{{" }} $labels.pod }} in namespace{{ "{{" }} $labels.namespace }} have a memory RSS (resident size) 2 times upper to its memory request in last day. Please increase the memory request to avoir OOm killer in case of memory contention'
          - alert: MissingMemoryRequest
            expr: |-
              avg by(container,pod,namespace) (
                 container_memory_rss{container=~".+"}
                 unless on(container,pod,namespace)
                 kube_pod_container_resource_requests{resource="memory"} > 0
              )
            for: 30m
            labels:
              severity: warning
            annotations:
              summary: 'Memory request is missing'
              description: 'container {{ "{{" }} $labels.container }} of pod {{ "{{" }} $labels.pod }} in namespace{{ "{{" }} $labels.namespace }} is missing a memory request. Please add the memory request to avoir OOm killer in case of memory contention'
          - alert: CpuOverReservation
            expr: |-
              (
                  sum by (namespace, pod, container) (kube_pod_container_resource_requests{resource="cpu"})
                  -
                  sum by (namespace, pod, container) (rate(container_cpu_usage_seconds_total{image!=""}[1m]))
                  > 0.010
              )
              and
              (
                  sum by (namespace, pod, container) (kube_pod_container_resource_requests{resource="cpu"})
                  /
                  sum by (namespace, pod, container) (rate(container_cpu_usage_seconds_total{image!=""}[1m]))
                  > 2
              )
            for: 24h
            labels:
              severity: warning
            annotations:
              summary: 'CPU is over requested'
              description: 'container {{ "{{" }} $labels.container }} of pod {{ "{{" }} $labels.pod }} in namespace{{ "{{" }} $labels.namespace }} is requesting 2 times more CPU than it\\s maximum usage in last day. Please reduce the cpu request to allow a better resource sharing'
          - alert: CpuUnderReservation
            expr: |-
              sum by (namespace,pod,container) (kube_pod_container_resource_requests{resource="cpu"})
              /
              sum by (namespace,pod,container) (max_over_time(rate(container_cpu_usage_seconds_total{image!=""}[1m])[1d:]))
              < 1
            for: 10m
            labels:
              severity: warning
            annotations:
              summary: 'CPU is under requested'
              description: 'container {{ "{{" }} $labels.container }} of pod {{ "{{" }} $labels.pod }} in namespace{{ "{{" }} $labels.namespace }} is requesting less CPU than it\\s maximum usage in last 24 hours. Please increase the cpu request to garantee resources allocation'
      - name: Upgrades
        rules:
          - alert: ApiserverRequestedDeprecatedApis
            expr: |-
              apiserver_requested_deprecated_apis > 0
            for: 1m
            labels:
              severity: warning
            annotations:
              summary: 'ApiserverRequestedDeprecatedApis'
              description: 'Apiserver receive requests for deprecated Apis. This must be corrected before next upgrade'
      - name: Applications
        rules:
          - alert: ContainerRestartsTooMuch
            expr: |-
              sum by(namespace,pod,container) (stdvar_over_time(kube_pod_container_status_restarts_total[1h])) > 1
            for: 1m
            labels:
              severity: warning
            annotations:
              summary: 'ContainerRestartsTooMuch'
              description: 'The container {{ "{{" }} $labels.container }} of pod {{ "{{" }} $labels.pod }} in namespace {{ "{{" }} $labels.namespace }} has restarted more than one time in tha last hour, please analyse the cause'
          - alert: ContainerProbeIsFlapping
            expr: |-
              sum by(namespace, pod, container, probe_type) (stddev_over_time(prober_probe_total{result="failed",probe_type!="Startup"}[10m])) > 2
            for: 1m
            labels:
              severity: warning
            annotations:
              summary: 'ContainerProbeIsFlapping'
              description: 'The {{ "{{" }} $labels.probe_type}} of container {{ "{{" }} $labels.container }} of pod {{ "{{" }} $labels.pod }} in namespace {{ "{{" }} $labels.namespace }} is flapping, please check the application'
{{- end }}

{{/* merged values : default + user  */}}
{{- define "monitoring.kubePrometheusStack.mergedValues" }}
{{- $me := .Values.components.monitoring.kubePrometheusStack }}
{{- $defaultValues := include "monitoring.kubePrometheusStack.defaultValues" . | fromYaml }}
{{- $customValues := $me.values | default dict }}
{{- mergeOverwrite $defaultValues $customValues | toYaml }}
{{- end }}

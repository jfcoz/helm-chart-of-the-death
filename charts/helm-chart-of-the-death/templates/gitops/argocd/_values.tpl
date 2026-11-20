{{/* values */}}
{{- define "gitops.argocd.defaultValues" }}
{{- $me := .Values.components.gitops.argocd }}
global:
  domain: {{ template "gitops.argocd.domain" . }}

server:
  ingress:
    {{- if include "common.used" .Values.components.ingress.nginxIngressController }}
    enabled: true
    ingressClassName: nginx
    annotations:
      {{- if include "common.used" .Values.components.security.certManager }}
      cert-manager.io/cluster-issuer: letsencrypt-production
      nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
      {{- end }}
    {{- end }}
    {{- if include "common.used" .Values.components.security.certManager }}
    tls: true
    {{- end }}

  ingressGrpc:
    {{- if include "common.used" .Values.components.ingress.nginxIngressController }}
    enabled: true
    ingressClassName: nginx
    {{- end }}
    {{- if include "common.used" .Values.components.security.certManager }}
    tls: true
    {{- end }}

  {{- if .Values.features.gatewayAPI.enabled }}
  {{- /* TODO: add variables */}}
  httproute:
    enabled: true
    hostnames:
      - argocd.{{ .Values.general.dnsWildcardSuffixes.gateway.cilium }}
    parentRefs:
    - group: gateway.networking.k8s.io
      kind: Gateway
      name: scaleway-gateway
      namespace: kube-system
      sectionName: https-prometheus
  {{- end }}
 

  {{- if include "common.used" .Values.components.security.certManager }}
  certificate:
    enabled: true
    issuer:
      group: cert-manager.io
      kind: ClusterIssuer
      name: {{ $me.issuer }}
  {{- end }}


  metrics:
    {{- if include "common.used" .Values.components.monitoring.kubePrometheusStack }}
    enabled: true
    serviceMonitor:
      enabled: true
    {{- else }}
    enabled: false
    {{- end }}
  resources:
    requests:
      cpu: 2m
      memory: 50M
  podAnnotations:
    cluster-autoscaler.kubernetes.io/safe-to-evict-local-volumes: "plugins-home,tmp"


controller:
  podAnnotations:
    cluster-autoscaler.kubernetes.io/safe-to-evict-local-volumes: "argocd-home,argocd-application-controller-tmp"
  revisionHistoryLimit: {{ .Values.general.revisionHistoryLimit }}
  metrics:
    {{- if include "common.used" .Values.components.monitoring.kubePrometheusStack }}
    enabled: true
    serviceMonitor:
      enabled: true
    {{- else }}
    enabled: false
    {{- end }}
  resources:
    requests:
      cpu: 5m
      memory: 40M

repoServer:
  podAnnotations:
    cluster-autoscaler.kubernetes.io/safe-to-evict-local-volumes: "helm-working-dir,plugins,var-files,tmp,gpg-keyring"
  metrics:
    {{- if include "common.used" .Values.components.monitoring.kubePrometheusStack }}
    enabled: true
    serviceMonitor:
      enabled: true
    {{- else }}
    enabled: false
    {{- end }}
  resources:
    requests:
      cpu: 5m
      memory: 40M

dex:
  logLevel: debug
  {{- if eq (len $me.dex_connectors) 0 }}
  enabled: false
  {{- end }}
  metrics:
    {{- if include "common.used" .Values.components.monitoring.kubePrometheusStack }}
    enabled: true
    serviceMonitor:
      enabled: true
    {{- else }}
    enabled: false
    {{- end }}
  resources:
    requests:
      cpu: 2m
      memory: 100M

redis:
  metrics:
    {{- if include "common.used" .Values.components.monitoring.kubePrometheusStack }}
    enabled: true
    serviceMonitor:
      enabled: true
    {{- else }}
    enabled: false
    {{- end }}
  resources:
    requests:
      cpu: 2m
      memory: 20M

applicationSet:
  podAnnotations:
    cluster-autoscaler.kubernetes.io/safe-to-evict-local-volumes: "gpg-keyring,tmp"
  metrics:
    {{- if include "common.used" .Values.components.monitoring.kubePrometheusStack }}
    enabled: true
    serviceMonitor:
      enabled: true
    {{- else }}
    enabled: false
    {{- end }}
  resources:
    requests:
      cpu: 2m
      memory: 20M

# TODO: only if notifications settings
notifications:
  metrics:
    {{- if include "common.used" .Values.components.monitoring.kubePrometheusStack }}
    enabled: true
    serviceMonitor:
      enabled: true
    {{- else }}
    enabled: false
    {{- end }}
  resources:
    requests:
      cpu: 2m
      memory: 40M

configs:
  cm:
    place_holder: "never empty"
    {{- if gt (len $me.dex_connectors) 0 }}
    dex.config: |
      connectors:
      {{- if $me.dex_connectors.github }}
      - type: github
        id: github
        name: GitHub
        config:
          clientID: {{ $me.dex_connectors.github.client.id | required "gitops.argocd.dex_connectors.github.client.id" }}
          clientSecret: {{ $me.dex_connectors.github.client.secret | required "gitops.argocd.dex_connectors.github.client.secret" }}
          orgs:
          {{ toYaml $me.dex_connectors.github.orgs | nindent 10 }}
      {{- end }}
      {{- with $me.dex_static_clients }}
      staticClients:
      {{- toYaml . | nindent 6 }}
      {{- end }}
    {{- end }}



# TODO

{{- end }}


{{/* merged values : default + user  */}}
{{- define "gitops.argocd.mergedValues" }}
{{- $me := .Values.components.gitops.argocd }}
{{- $defaultValues := include "gitops.argocd.defaultValues" . | fromYaml }}
{{- $customValues := $me.values | default dict }}
{{- mergeOverwrite $defaultValues $customValues | toYaml }}
{{- end }}

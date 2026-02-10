{{/* values */}}
{{- define "ingress.nginxIngressController.defaultValues" }}
controller:
  # TODO: nodeSelector based on nodes with nat rules on 80/443
  # preserve client source ip
  externalTrafficPolicy: Local
  resources:
    requests:
      memory: 300M
  service:
    externalTrafficPolicy: Local
  metrics:
    enabled: true
    {{- if include "common.used" .Values.components.monitoring.kubePrometheusStack }}
    serviceMonitor:
      enabled: true
    {{- end }}
  #opentelemetry:
  #  enabled: true
  config:
    # begin opentelemetry
    # https://kubernetes.github.io/ingress-nginx/user-guide/third-party-addons/opentelemetry/
    #enable-opentelemetry: "true"
    #opentelemetry-config: "/etc/nginx/opentelemetry.toml"
    #opentelemetry-operation-name: "HTTP $request_method $service_name $uri"
    #opentelemetry-trust-incoming-span: "true"
    #otlp-collector-host: "collector-collector.infra-opentelemetry"
    #otlp-collector-port: "4317"
    #otel-max-queuesize: "2048"
    #otel-schedule-delay-millis: "5000"
    #otel-max-export-batch-size: "512"
    #otel-service-name: "infra-nginx-ingress"
    # Also: AlwaysOff, TraceIdRatioBased
    #otel-sampler: "AlwaysOn"
    #otel-sampler-ratio: "1.0"
    #otel-sampler-parent-based: "false"
    # end opentelemetry
{{- end }}


{{/* merged values : default + user  */}}
{{- define "ingress.nginxIngressController.mergedValues" }}
{{- $me := .Values.components.ingress.nginxIngressController }}
{{- $defaultValues := include "ingress.nginxIngressController.defaultValues" . | fromYaml }}
{{- $customValues := $me.values | default dict }}
{{- mergeOverwrite $defaultValues $customValues | toYaml }}
{{- end }}

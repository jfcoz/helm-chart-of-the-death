{{/* alertManager endpoint */}}
{{- define "monitoring.kubePrometheusStack.alertManagerEndpoint" -}}
http://prometheus-kube-prometheus-alertmanager.{{ .Values.components.monitoring.kubePrometheusStack.namespace}}:9093
{{- end }}

{{/* prometheus write endpoint */}}
{{- define "monitoring.kubePrometheusStack.prometheusWriteEndpoint" -}}
http://prometheus-kube-prometheus-prometheus.{{ .Values.components.monitoring.kubePrometheusStack.namespace}}:9090
{{- end }}

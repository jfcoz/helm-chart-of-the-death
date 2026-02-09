{{/* values for deploymentMode=SingleBinary */}}
{{- define "monitoring.loki.deploymentMode.singleBinary" }}
{{- $me := .Values.components.monitoring.loki }}
deploymentMode: SingleBinary
chunksCache:
  enabled: false
resultsCache:
  enabled: false
compactor:
  enabled: false
## test requires lokiCanary
test:
  enabled: false
lokiCanary:
  enabled: false
distributor:
  enabled: false
queryFrontend:
  enabled: false
queryScheduler:
  enabled: false
ingester:
  enabled: false
patternIngester:
  enabled: false
querier:
  enabled: false
ruler:
  enabled: false
indexGateway:
  replicas: 0
bloomPlanner:
 replicas: 0
bloomBuilder:
  replicas: 0
bloomGateway:
  replicas: 0

# deploymentMode: SimpleScalable only, so we disable it
backend:
   replicas: 0
read:
   replicas: 0
write:
   replicas: 0

# deploymentMode: SingleBinary only
singleBinary:
   replicas: 1
{{- end }}


{{/* values for deploymentMode=SimpleScalable */}}
{{- define "monitoring.loki.deploymentMode.simpleScalable" }}
{{- $me := .Values.components.monitoring.loki }}
deploymentMode: SimpleScalable
chunksCache:
  enabled: false
resultsCache:
  enabled: false
compactor:
  enabled: false
## test requires lokiCanary
test:
  enabled: false
lokiCanary:
  enabled: false
distributor:
  enabled: false
queryFrontend:
  enabled: false
queryScheduler:
  enabled: false
ingester:
  enabled: false
patternIngester:
  enabled: false
querier:
  enabled: false
ruler:
  enabled: false
indexGateway:
  replicas: 0
bloomPlanner:
 replicas: 0
bloomBuilder:
  replicas: 0
bloomGateway:
  replicas: 0

# deploymentMode: SimpleScalable only
backend:
   replicas: 3
read:
   replicas: 3
write:
   replicas: 3

# deploymentMode: SingleBinary only, so we disable it
singleBinary:
   replicas: 0
{{- end }}


{{/* values for deploymentMode=Distributed */}}
{{- define "monitoring.loki.deploymentMode.distributed" }}
{{- $me := .Values.components.monitoring.loki }}
deploymentMode: Distributed
chunksCache:
  # in Mb, default 8096
  allocatedMemory: 64
  resources:
    requests:
      # default: 1.2 allocatedMemory
      memory: 80M
      cpu: 10m
resultsCache:
  # in Mb, default 1024
  allocatedMemory: 128
  resources:
    requests:
      cpu: 10m
      # default: 1.2 allocatedMemory
      memory: 150
compactor:
  replicas: 1
  resources:
    requests:
      cpu: 10m
      memory: 100M
    limits:
      memory: 200M
  #persistence:
  #  enabled: true
  #  enableStatefulSetAutoDeletePVC: true
  #  whenDeleted: Delete
  #  whenScaled: Delete
  #  claims:
  #    - name: data
  #      size: 1Gi
  #      accessModes:
  #      - ReadWriteOnce
  #      storageClass: ceph-block
# disable lokiCanary. It makes lots of requests/volume/logs to monitor latency
lokiCanary:
  enabled: false
# test requires lokiCanary
test:
  enabled: false
distributor:
  autoscaling:
    enabled: true
    # default 60
    targetCPUUtilizationPercentage: 90
  resources:
    requests:
      cpu: 100m
      memory: 70M
    limits:
      memory: 100M
queryFrontend:
  autoscaling:
    enabled: true
    # default 60
    targetCPUUtilizationPercentage: 90
  maxUnavailable: 1
  resources:
    requests:
      cpu: 20m
      memory: 150M
    limits:
      memory: 200M
queryScheduler:
  replicas: 1
  # Not available
  #autoscaling:
  #  enabled: true
  # Current default
  #maxUnavailable: 1
  resources:
    requests:
      cpu: 10m
      memory: 50M
    limits:
      memory: 200M
#gateway:
#  resources:
#    requests:
#      cpu: 1m
#      memory: 20M
#    limits:
#      memory: 20M
ingester:
  enabled: true
  autoscaling:
    enabled: true
    # at least 2 live replicas required, could only find 1
    minReplicas: 2
    # default 60
    targetCPUUtilizationPercentage: 90
  zoneAwareReplication:
    # default true
    enabled: false
  ## needed for rollout-operator, if ingester zoneAwareReplication is enabled
  #updateStrategy:
  #  type: OnDelete
  resources:
    requests:
      cpu: 60m
      memory: 200M
    limits:
      memory: 2000M
  #persistence:
  #  enabled: true
  #  enableStatefulSetAutoDeletePVC: true
  #  whenDeleted: Delete
  #  whenScaled: Delete
  #  claims:
  #  - name: data
  #    size: 1Gi
  #    accessModes:
  #    - ReadWriteOnce
  #    storageClass: ceph-block
  extraArgs:
    # default log level is info
    - -log.level=warn
patternIngester:
  replicas: 1
  maxUnavailable: 1
  resources:
    requests:
      cpu: 20m
      memory: 100M
  extraArgs:
    # default log level is info
    - -log.level=warn
querier:
  autoscaling:
    enabled: true
    # default 60
    targetCPUUtilizationPercentage: 90
  maxUnavailable: 1
  resources:
    requests:
      cpu: 50m
      memory: 100M
    #limits:
    #  memory: 100M
## if zoneAwareReplication is enabled, rollout operator is needed
## found and existing instance with a problem in the ring : https://github.com/grafana/loki/issues/17822
#rollout_operator:
#  enabled: true
ruler:
  # https://github.com/grafana/loki/issues/16599#issuecomment-3532876591
  storage:
    type: local
indexGateway:
  replicas: 1
  # Not available
  #autoscaling:
  #  enabled: true
  maxUnavailable: 1
  resources:
    requests:
      cpu: 10m
      memory: 50M
    limits:
      memory: 200M
  extraArgs:
    # default log level is info
    - -log.level=warn

# Cf https://grafana.com/docs/loki/latest/setup/install/helm/install-microservices/
bloomPlanner:
 replicas: 0
bloomBuilder:
  replicas: 0
bloomGateway:
  replicas: 0

# deploymentMode: SimpleScalable only, so we disabel 
backend:
   replicas: 0
read:
   replicas: 0
write:
   replicas: 0

# deploymentMode: SingleBinary only, so we disable
singleBinary:
   replicas: 0
{{- end }}

{{/* values for deploymentMode */}}
{{- define "monitoring.loki.deploymentMode" }}
{{- $me := .Values.components.monitoring.loki }}
{{- if eq $me.config.deploymentMode "Distributed" }}
{{- template "monitoring.loki.deploymentMode.distributed" . }}
{{- else if eq $me.config.deploymentMode "SimpleScalable" }}
{{- template "monitoring.loki.deploymentMode.simpleScalable" . }}
{{- else if eq $me.config.deploymentMode "SingleBinary" }}
{{- template "monitoring.loki.deploymentMode.singleBinary" . }}
{{- else }}
{{- fail "unknown deploymentMode" }}
{{- end }}
{{- end }}

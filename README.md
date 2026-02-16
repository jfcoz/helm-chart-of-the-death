# Helm chart of the death

_One chart to rule them all_

`helm-chart-of-the-death` is an umbrella chart to manage most common helm releases of tools commonly used on each Kubernetes cluster.

It needs the use of [FluxCD](https://fluxcd.io/), because each tool is deployed via a `HelmRelease`.

By enabling any tool, all other tools configurations will be updated to work correctly with this tool.

As an example, if you enable the log collection with Envy:
- the Kyverno admission controller, will exclude the Envy DaemonSet from the `disallow-host-path` ClusterPolicy.
- based on Loki deploymentMode, Envy will send logs to the correct endpoint.

## Components

A lot of common components can be enabled:
- security: [cert-manager](https://cert-manager.io/), [falco](https://falco.org/), [kyverno](https://kyverno.io), [trivy](https://trivy.dev/)...
- monitoring: [Grafana](https://grafana.com/grafana/) and [Prometheus](https://prometheus.io/) via [kube-prometheus-stack](https://github.com/prometheus-community/helm-charts/blob/main/charts/kube-prometheus-stack/README.md), [Loki](https://grafana.com/oss/loki/), [Promtail](https://github.com/grafana/helm-charts/tree/main/charts/promtail), [Alloy](https://grafana.com/docs/alloy/latest/), [opentelemetry-operator](https://opentelemetry.io/docs/platforms/kubernetes/operator/), [smartctl-exporter](https://github.com/prometheus-community/smartctl_exporter), [x509-certificate-exporter](https://github.com/enix/x509-certificate-exporter)...
- database: [CloudNative-PG](https://cloudnative-pg.io/), [cnpg-plugin-barman-cloud](https://cloudnative-pg.io/plugin-barman-cloud/)...

### Components

For each component a default managed values will be used, and will be merged to you passed values:

```yaml
components:
  security:
    kyverno:
      managed: true
      values:
        admissionController:
          replicas: 2
```

### Managed vs Used components

- `managed: true`: the chart will deploy and managed the component
- `used: true`: the component is already deployed: other components will update their configuration to work with it

## Usage

Use `OCIRepository` to use releases only, or `GitRepository` if you want the latest/test another branch

```yaml
# infrastructure/helm-chart-of-the-death/$cluster/gitrepo.yaml
apiVersion: source.toolkit.fluxcd.io/v1
kind: GitRepository
metadata:
  name: helm-chart-of-the-death
  namespace: flux-system
spec:
  interval: 1m
  url: https://github.com/jfcoz/helm-chart-of-the-death
  ref:
    branch: main
```

```yaml
# infrastructure/helm-chart-of-the-death/$cluster/ocirepo.yaml
apiVersion: source.toolkit.fluxcd.io/v1
kind: OCIRepository
metadata:
  name: helm-chart-of-the-death
  namespace: flux-system
spec:
  interval: 5m
  url: oci://ghcr.io/jfcoz/helm-chart-of-the-death/helm-chart-of-the-death
  ref:
    tag: 0.2.7
  verify:
    provider: cosign
    matchOIDCIdentity:
      - issuer: "^https://token.actions.githubusercontent.com$"
        subject: "^https://github.com/jfcoz/helm-chart-of-the-death.*$"
```

```yaml
# infrastructure/helm-chart-of-the-death/$cluster/helmrelease.yaml
apiVersion: helm.toolkit.fluxcd.io/v2
kind: HelmRelease
metadata:
  name: helm-chart-of-the-death
  namespace: flux-system
spec:
  interval: 1m
  timeout: 10m
  # when using releases from OCIRepository
  chartRef:
    kind: OCIRepository
    name: helm-chart-of-the-death
    namespace: flux-system
  # Or GitRepository for testing on branch
  chart:
    spec:
      chart: ./charts/helm-chart-of-the-death
      # needed when source is GitRepository and Chart version does not change
      reconcileStrategy: Revision
      sourceRef:
        kind: GitRepository
        name: helm-chart-of-the-death
        namespace: flux-system
      interval: 1h
  install:
    crds: Create
  upgrade:
    crds: CreateReplace
    remediation:
      retries: 3
  driftDetection:
    mode: enabled
  test:
    enable: true
  values:
    ...
    components:
      monitoring:
         keda:
           managed: true
         kubePrometheusStack:
           managed: true
         thanos:
           managed: true
         loki:
           managed: true
           config:
             deploymentMode: Distributed
      ...
```

See [chart documentation for all available components](charts/helm-chart-of-the-death)

```yaml
# infrastructure/helm-chart-of-the-death/$cluster/helmrelease.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
- helmrelease.yaml
# keep one source
- gitrepo.yaml
- ocirepo.yaml
spec:
  wait: true
```

```yaml
# clusters/$cluster/helm-chart-of-the-death.yaml
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: helm-chart-of-the-death
  namespace: flux-system
spec:
  interval: 1h
  sourceRef:
    kind: GitRepository
    name: flux-system
  path: ./infrastructure/helm-chart-of-the-death/$cluster
  prune: false
  # Use postBuild if needed
  #dependsOn:
  #  - name: flux-system
  #    namespace: flux-system
  #postBuild:
  #  substituteFrom:
  #    - kind: ConfigMap
  #      name: global-config
  #    - kind: Secret
  #      name: global-secret
```

## Uninstall

the helm resource policy keep annotation is set on all objects, to prevent objects removal in case of misused:

Each component has by default
```
helmResourcePolicyKeep: true
```

To remove it, first set this to false, and after, set enabled to false

## Similar projets

- [DoD-Platform-One/BigBang](https://github.com/DoD-Platform-One/bigbang/tree/master): DoD DevSecOps Reference Architecture

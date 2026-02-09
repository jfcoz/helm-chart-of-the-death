# Helm chart of the death

_One chart to rule them all_

`helm-chart-of-the-death` is an umbrella chart to manage most common helm releases of tools commonly used on each Kubernetes cluster.

It needs the use of [FluxCD](https://fluxcd.io/), because each tool is deployed via a `HelmRelease`.

By enabling any tool, all other tools configurations will be updated to work correctly with this tool.

As an example, if you enable the log collection with Envy:
- the Kyverno admission controller, will exclude the Envy DaemonSet from the `disallow-host-path` ClusterPolicy.
- based on Loki deploymentMode, Envy will send logs to the correct endpoint.


## Uninstall

the helm resource policy keep annotation is set on all objects, to prevent objects removal in case of misused:

Each component has by default
```
helmResourcePolicyKeep: true
```

To remove it, first set this to false, and after, set enabled to false

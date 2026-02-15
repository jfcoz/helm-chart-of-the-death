# Helm-chart-of-the-death

_One chart to rule them all_

## TL;DR;

```bash
helm repo add helm-chart-of-the-death https://jfcoz.github.io/helm-chart-of-the-death/
helm template helm-chart-of-the-death/helm-chart-of-the-death \
  --set components.monitoring.kubePrometheusStack.enabled=true \
  --set components.monitoring.loki.enabled=true \
  …
```

## For more informations

- [Helm-chart-of-the-death repository](https://github.com/jfcoz/helm-chart-of-the-death)
- [values.yaml](https://github.com/jfcoz/helm-chart-of-the-death/blob/main/charts/helm-chart-of-the-death/values.yaml)

## Raw index

[Raw index](index.yaml)

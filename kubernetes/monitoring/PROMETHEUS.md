# Monitoring with Prometheus and Grafana

## Install Prometheus into Kubernetes

### 1. Install Prometheus via Helm

```bash
helm repo add stable https://kubernetes-charts.storage.googleapis.com
```

```bash
helm upgrade prometheus stable/prometheus \
    --install \
    --set server.service.type=LoadBalancer
```

### 2. Add annotations to the Pods

```yaml
annotations:
  prometheus.io/scrape: "true"
  prometheus.io/path: /metrics
  prometheus.io/port: "8080"
```

### 3. Install Grafana

```bash
helm upgrade grafana stable/grafana \
    --install \
    --set service.type=LoadBalancer
```

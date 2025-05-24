# Create observability namespace
# Deploy OpenTelemetry
# Deploy Tempo
# Deploy Loki
# Deploy Mirmir

terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.32.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "2.15.0"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "observability_namespace" {
  metadata {
    name = "observability"
  }
}

resource "helm_release" "otel-collector" {
  name       = "otel-collector"
  repository = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  chart      = "opentelemetry-collector"
  version    = "v0.104.0"

  cleanup_on_fail = true
  timeout         = 60

  create_namespace = false
  namespace        = kubernetes_namespace.observability_namespace.metadata[0].name

  values = [<<-EOF
    mode: daemonset
    image:
      repository: "otel/opentelemetry-collector-k8s"

    presets:
      hostMetrics:
        enabled: true
      kubernetesAttributes:
        enabled: true
      kubeletMetrics:
        enabled: true
      logsCollection:
        enabled: true

    config:
      # receivers:
      #   filelog:
      #     include: ["/var/log/containers/*.log"]

      processors:
        batch: {}
        resource:
          attributes:
            - action: insert
              key: loki.resource.labels
              value: k8s.namespace.name,k8s.pod.name,k8s.container.name

      exporters:
        otlphttp/loki:
          endpoint: "http://loki:3100/otlp"  # Loki endpoint for log ingestion
        otlphttp/mimir:
          endpoint: http://mimir-nginx/otlp

      service:
        pipelines:
          logs:
            # receivers: [filelog]
            processors:
              - memory_limiter
              - k8sattributes
              - resource
              - batch
            exporters:
              - otlphttp/loki
          metrics:
            processors:
              - memory_limiter
              - k8sattributes
              - resource
              - batch
            exporters:
              - otlphttp/mimir
  EOF
  ]
}

resource "helm_release" "loki" {
  name       = "loki"
  namespace  = kubernetes_namespace.observability_namespace.metadata[0].name
  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki"


  values = [<<-EOF
    deploymentMode: SingleBinary
    loki:
      limits_config:
        allow_structured_metadata: true
      auth_enabled: false
      commonConfig:
        replication_factor: 1
      storage:
        type: 'filesystem'
      schemaConfig:
        configs:
        - from: "2024-01-01"
          store: tsdb
          index:
            prefix: loki_index_
            period: 24h
          object_store: filesystem # we're storing on filesystem so there's no real persistence here.
          schema: v13
    singleBinary:
      replicas: 1
    read:
      replicas: 0
    backend:
      replicas: 0
    write:
      replicas: 0
    chunksCache:
      enabled: false
  EOF
  ]
}

resource "helm_release" "mimir" {
  name       = "mimir"
  namespace  = kubernetes_namespace.observability_namespace.metadata[0].name
  repository = "https://grafana.github.io/helm-charts"
  chart      = "mimir-distributed"
  timeout    = 300

  values = [<<-EOF
    api:
      enable: true
    distributor:
      replicas: 1
    ingester:
      replicas: 1
    query-frontend:
      replicas: 1
    querier:
      replicas: 1
  EOF
  ]
}

# resource "helm_release" "tempo" {
#   name       = "tempo"
#   namespace  = kubernetes_namespace.observability_namespace.metadata[0].name
#   repository = "https://grafana.github.io/helm-charts"
#   chart      = "tempo"
#   timeout    = 120

#   values = [
#     yamlencode({
#       config = <<-EOT
#         distributor:
#           ring:
#             kvstore:
#               store: inmemory
#         ingester:
#           lifecycler:
#             ring:
#               kvstore:
#                 store: inmemory
#         compactor:
#           ring:
#             kvstore:
#               store: inmemory
#         server:
#           http_listen_port: 8080
#       EOT
#     })
#   ]
# }

# Deploy Grafana for visualization
resource "helm_release" "grafana" {
  name            = "grafana"
  namespace       = kubernetes_namespace.observability_namespace.metadata[0].name
  repository      = "https://grafana.github.io/helm-charts"
  chart           = "grafana"
  version         = "8.5.1"
  timeout         = 45
  cleanup_on_fail = true

  values = [<<-EOF
    adminPassword: "admin"

    persistence:
      enabled: true
      size: 1Gi
      storageClassName: openebs-hostpath

    service:
      type: ClusterIP
      port: 80

    datasources:
      datasources.yaml:
        apiVersion: 1
        datasources:
          - name: Loki
            type: loki
            url: http://loki:3100
            access: proxy

          - name: Prometheus
            type: prometheus
            url: http://mimir-nginx/prometheus
            access: proxy
            isDefault: true

          - name: Tempo
            type: tempo
            url: http://tempo:3100
            access: proxy
  EOF
  ]
}

resource "kubernetes_manifest" "grafana_endpoint" {
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "HTTPRoute"
    metadata = {
      name      = "grafana-route"
      namespace = "observability"
    }
    spec = {
      parentRefs = [
        {
          name      = "gw"
          namespace = "default"
        }
      ]
      hostnames = [
        "grafana.kevharv.com"
      ]
      rules = [
        {
          backendRefs = [
            {
              group     = ""
              kind      = "Service"
              name      = "grafana"
              namespace = "observability"
              port      = 80
              weight    = 1
            }
          ]
          matches = [
            {
              path = {
                type  = "PathPrefix"
                value = "/"
              }
            }
          ]
        }
      ]
    }
  }
}

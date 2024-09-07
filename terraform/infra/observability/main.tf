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

  create_namespace = false
  namespace        = kubernetes_namespace.observability_namespace.metadata[0].name

  values = [<<-EOF
    mode: deployment
    image:
      repository: "otel/opentelemetry-collector-k8s"
    
    config:
      receivers:
        filelog:
          include: ["/var/log/containers/*.log"]

      processors:
        batch: {}

      exporters:
        otlphttp:
          endpoint: "http://loki:3100/otlp/v1/logs"  # Loki endpoint for log ingestion

      service:
        pipelines:
          logs:
            receivers: [filelog]
            processors: [batch]
            exporters: [otlphttp]
  EOF
  ]
}

resource "helm_release" "loki" {
  name       = "loki"
  namespace  = kubernetes_namespace.observability_namespace.metadata[0].name
  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki-stack"
  version    = "2.10.2"

  values = [<<-EOF
    loki:
      persistence:
        enabled: true
        size: 1Gi
        storageClassName: openebs-hostpath
    promtail:
      enabled: false
  EOF
  ]
}

# resource "helm_release" "mimir" {
#   name       = "mimir"
#   namespace  = kubernetes_namespace.observability_namespace.metadata[0].name
#   repository = "https://grafana.github.io/helm-charts"
#   chart      = "mimir-distributed"
#   version    = "5.5.0-weekly.306"

#   values = [<<-EOF
#     api:
#       enable: true
#     distributor:
#       replicas: 1
#     ingester:
#       replicas: 1
#     query-frontend:
#       replicas: 1
#     querier:
#       replicas: 1
#   EOF
#   ]
# }

# resource "helm_release" "tempo" {
#   name       = "tempo"
#   namespace  = kubernetes_namespace.observability_namespace.metadata[0].name
#   repository = "https://grafana.github.io/helm-charts"
#   chart      = "tempo"
#   version    = "1.10.3"

#   values = [<<-EOF
#     config:
#       distributor:
#         ring:
#           kvstore:
#             store: inmemory
#       ingester:
#         lifecycler:
#           ring:
#             kvstore:
#               store: inmemory
#       compactor:
#         ring:
#           kvstore:
#             store: inmemory
#   EOF
#   ]
# }

# Deploy Grafana for visualization
resource "helm_release" "grafana" {
  name       = "grafana"
  namespace  = kubernetes_namespace.observability_namespace.metadata[0].name
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  version    = "8.5.1" # Adjust to latest version

  values = [<<-EOF
    adminPassword: "admin"

    service:
      type: ClusterIP
      port: 80
    
    grafana.ini:
      server:
        httpPort: 80
        rootUrl: "https://k8s.kevharv.com:32158/grafana/"
        domain: "https://k8s.kevharv.com:32158/grafana/"

    datasources:
      datasources.yaml:
        apiVersion: 1
        datasources:
          - name: Prometheus
            type: prometheus
            url: http://mimir-observability:9009/api/prom
            access: proxy
            isDefault: true

          - name: Loki
            type: loki
            url: http://loki:3100
            access: proxy

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
        "k8s.kevharv.com"
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
                value = "/grafana"
              }
            }
          ]
        }
      ]
    }
  }
}
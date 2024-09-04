# Kubernetes Core Infrastructure

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


# ========== CNI ==========

# To-Do - maybe Cilium, or at least get Flannel modeled here


# ========== OpenEBS ==========
resource "helm_release" "openebs" {
  name       = "openebs"
  repository = "https://openebs.github.io/openebs"
  chart      = "openebs"

  cleanup_on_fail = true

  create_namespace = true
  namespace        = "openebs"

  set {
    name  = "engines.replicated.mayastor.enabled"
    value = "false"
  }
}


# ========== Envoy Gateway ==========
resource "helm_release" "envoy_gateway" {
  name       = "envoy-gateway"
  repository = "oci://registry-1.docker.io/envoyproxy"
  chart      = "gateway-helm"
  version    = "v1.1.0"

  create_namespace = true
  namespace        = "envoy-gateway"
}

resource "helm_release" "envoy_gateway_addon" {
  name       = "envoy-gateway-addon"
  repository = "oci://docker.io/envoyproxy"
  chart      = "gateway-addons-helm"
  version    = "v0.0.0-latest"


  create_namespace = true
  namespace        = "monitoring"

  set {
    name  = "opentelemetry-collector.enabled"
    value = "false"
  }

  set {
    name  = "loki.enabled"
    value = "false"
  }

  set {
    name  = "grafana.enabled"
    value = "false"
  }

  set {
    name  = "tempo.service.type"
    value = "ClusterIP"
  }

  set {
    name  = "prometheus.server.service.type"
    value = "ClusterIP"
  }
}

resource "kubernetes_manifest" "envoy_gateway_class" {
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "GatewayClass"
    metadata = {
      name = "eg"
    }
    spec = {
      controllerName = "gateway.envoyproxy.io/gatewayclass-controller"
    }
  }
}

resource "kubernetes_manifest" "public_gateway" {
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "Gateway"
    metadata = {
      name      = "gw"
      namespace = "default"
      annotations = {
          "cert-manager.io/cluster-issuer" = "self-signed-cluster-issuer"
        }
    }
    spec = {
      gatewayClassName = "eg"
      listeners = [
        # {
        #   name     = "http"
        #   hostname = "*.kevharv.com"
        #   protocol = "HTTP"
        #   port     = 80
        #   allowedRoutes = {
        #     namespaces = {
        #       from = "All"
        #     }
        #   }
        # },
        {
          name = "https"
          hostname = "*.kevharv.com"
          protocol = "HTTPS"
          port = 443
          allowedRoutes = {
            namespaces = {
              from = "All"
            }
          }
          tls = {
            mode = "Terminate"
            certificateRefs = [
              {
                name = "wildcard-kevharv-com-tls"
              }
            ]
          }
        }
      ]
    }
  }
}


# ========== Cert Manager ==========
resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.15.3"

  create_namespace = true
  namespace        = "cert-manager"

  set {
    name  = "crds.enabled"
    value = "true"
  }

  set {
    name  = "prometheus.enabled"
    value = "true"
  }

  set {
    name = "config.apiVersion"
    value = "controller.config.cert-manager.io/v1alpha1"
  }

  set {
    name = "config.kind"
    value = "ControllerConfiguration"
  }

  set {
    name = "config.enableGatewayAPI"
    value = "true"
  }
}

resource "kubernetes_manifest" "self_signed_cluster_issuer" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = {
      name      = "self-signed-cluster-issuer"
    }
    spec = {
      selfSigned = {}
    }
  }
}

# To-Do - create ClusterIssuer with DNS01 ACME challenge against Cloudflare
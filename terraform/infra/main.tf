# Kubernetes Core Infrastructure

terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.32.0"
    }

    helm = {
      source = "hashicorp/helm"
      version = "2.15.0"
    }
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
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
  namespace = "openebs"

  set {
    name  = "engines.replicated.mayastor.enabled"
    value = "false"
  }
}

# To-Do - enable replicated storage once host firewall configs are updated to allow it


# ========== Envoy Gateway ==========
resource "helm_release" "envoy_gateway" {
    name = "envoy-gateway"
    repository = "oci://registry-1.docker.io/envoyproxy"
    chart = "gateway-helm"
    version = "v1.1.0"

    create_namespace = true
    namespace = "envoy-gateway"
}

# To-Do - deploy shared Gateway resource
# To-Do - deploy Envoy metrics add-on


# ========== Cert Manager ==========
resource "helm_release" "cert_manager" {
    name = "cert-manager"
    repository = "https://charts.jetstack.io"
    chart = "cert-manager"
    version = "v1.15.3"

    create_namespace = true
    namespace = "cert-manager"

    set {
        name = "crds.enabled"
        value = "true"
    }

    set {
        name = "prometheus.enabled"
        value = "true"
    }
}

# To-Do - create ClusterIssuer with DNS01 ACME challenge against Cloudflare
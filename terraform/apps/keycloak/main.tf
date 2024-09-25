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

variable "kc_pg_username" {
  type = string
}

variable "kc_pg_password" {
  type      = string
  sensitive = true
}

variable "kc_pg_host" {
  type = string
}

variable "kc_pg_database" {
  type = string
}


# resource "kubernetes_namespace" "security_namespace" {
#   metadata {
#     name = "security"
#   }
# }

# resource "helm_release" "keycloak" {
#   name       = "keycloak"
#   namespace  = kubernetes_namespace.security_namespace.metadata[0].name
#   repository = "oci://registry-1.docker.io/bitnamicharts"
#   chart      = "keycloak"

#   cleanup_on_fail = true

#   set {
#     name  = "postgresql.enabled"
#     value = true
#   }
#   set {
#     name  = "auth.adminUser"
#     value = "admin"
#   }
#   set {
#     name  = "auth.adminPassword"
#     value = var.kc_pg_password
#   }
#   set {
#     name  = "externalDatabase.host"
#     value = var.kc_pg_host
#   }
#   set {
#     name  = "externalDatabase.user"
#     value = var.kc_pg_username
#   }
#   set {
#     name  = "externalDatabase.password"
#     value = var.kc_pg_password
#   }
#   set {
#     name  = "externalDatabase.database"
#     value = var.kc_pg_database
#   }
#   set {
#     name  = "externalDatabase.port"
#     value = 5432
#   }
#   set {
#     name  = "keycloak.extraEnvVars[0].name"
#     value = "KEYCLOAK_PRODUCTION"
#   }
#   set {
#     name  = "keycloak.extraEnvVars[0].value"
#     value = "true"
#   }
#   set {
#     name  = "keycloak.extraEnvVars[1].name"
#     value = "KEYCLOAK_LOGLEVEL"
#   }
#   set {
#     name  = "keycloak.extraEnvVars[1].value"
#     value = "DEBUG"
#   }
#   set {
#     name  = "keycloak.extraEnvVars[2].name"
#     value = "KEYCLOAK_AUTO_MIGRATION"
#   }
#   set {
#     name  = "keycloak.extraEnvVars[2].value"
#     value = "true"
#   }
# }

resource "kubernetes_manifest" "keycloak_endpoint" {
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "HTTPRoute"
    metadata = {
      name      = "keycloak-route"
      namespace = "security"
    }
    spec = {
      parentRefs = [
        {
          name      = "gw"
          namespace = "default"
        }
      ]
      hostnames = [
        "keycloak.lab.kevharv.com"
      ]
      rules = [
        {
          backendRefs = [
            {
              group     = ""
              kind      = "Service"
              name      = "keycloak"
              namespace = "security"
              port      = 8080
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
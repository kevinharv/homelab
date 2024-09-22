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

variable "pg_username" {
  type = string
}

variable "pg_password" {
  type = string
  sensitive = true
}

resource "helm_release" "postgresql" {
  name       = "postgresql"
  namespace  = "default"
  repository = "oci://registry-1.docker.io/bitnamicharts"
  chart      = "postgresql"

  cleanup_on_fail = true

  set {
    name  = "global.postgresql.auth.username"
    value = var.pg_username
  }
  set {
    name  = "global.postgresql.auth.password"
    value = var.pg_password
  }
  set {
    name = "global.postgresql.auth.postgresPassword"
    value = var.pg_password
  }
}

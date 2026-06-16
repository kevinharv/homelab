terraform {
  required_version = "~> 1.14"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.109.0, < 1.0.0"
    }
  }

  backend "s3" {
    bucket       = "kharvey-homelab-terraform-state"
    key          = "tfstate/homelab/v2/pve-prod.tf"
    region       = "us-east-1"
    use_lockfile = true
  }
}

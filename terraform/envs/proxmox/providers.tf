/*
    Provider configuration for Proxmox VE for QEMU VMs and LXC
    containers.

    REQUIRED VARS
    - proxmox_hostname
    - proxmox_tokenID
    - proxmox_token
*/

terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.1-rc10"
    }
  }
}

provider "proxmox" {
  pm_api_url          = "https://${var.proxmox_hostname}/api2/json"
  pm_api_token_id     = var.proxmox_tokenID
  pm_api_token_secret = var.proxmox_token
  pm_tls_insecure     = true
}
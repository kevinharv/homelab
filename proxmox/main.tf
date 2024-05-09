terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.1-rc1"
    }
  }
}

provider "proxmox" {
  pm_api_url          = "https://192.168.1.10:8006/api2/json"
  pm_api_token_id     = var.proxmox_tokenID
  pm_api_token_secret = var.proxmox_token
  pm_tls_insecure     = true
}

# -------------- Configuration Variables --------------
variable "proxmox_tokenID" {
  description = "Proxmox API Access Token ID"
  type        = string
}

variable "proxmox_token" {
  description = "Proxmox API Access Token"
  type        = string
}

variable "ssh_key" {
  description = "Default SSH Keys"
  type        = string
}

# -------------- Kubernetes Control Plane Node 1 --------------
resource "proxmox_vm_qemu" "PRDKUBCP1" {
  name        = "PRDKUBCP1"
  desc        = "Production Kubernetes Control Plane Node 1"
  target_node = "prox1"
  vmid        = 201

  # Clone from RHEL 9 Template
  os_type = "cloud-init"
  clone   = "R9-TEMPL-NOSWAP"

  # Hardware configuration
  cores   = 2
  sockets = 1
  memory  = 4096
  scsihw  = "virtio-scsi-single"
  balloon = 1
  agent   = 1

  # Boot configuration
  cloudinit_cdrom_storage = "local-lvm"
  boot                    = "order=scsi0;ide3"

  disks {
    scsi {
      scsi0 {
        disk {
          size    = 30
          cache   = "writeback"
          storage = "local-lvm"
        }
      }
    }
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
    macaddr = "DE:5A:BA:C4:82:8E"
  }

  # Cloud-init user and SSH key
  ciuser  = "kevin"
  sshkeys = var.ssh_key
}

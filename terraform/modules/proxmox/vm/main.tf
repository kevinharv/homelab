/*
    VM module for standard configuration virtual server resource.
*/

terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.2-rc03"
    }
  }
}

resource "proxmox_vm_qemu" "vm" {
  # VM Metadata
  vmid        = var.vmid
  name        = var.name
  # desc        = var.description
  description = var.description
  clone       = var.template_name
  target_node = var.pve_node
  vm_state    = var.vm_state

  # Misc. Hypervisor Config
  os_type    = "cloud-init"
  full_clone = false
  scsihw     = "virtio-scsi-pci"
  balloon    = 1
  agent      = 1

  # Configure Cloud Init
  ciuser       = var.cloud_init_user
  cipassword   = var.cloud_init_password
  sshkeys      = var.cloud_init_ssh_key
  ipconfig0    = "ip=${var.vm_cidr},gw=${var.network_gateway_cidr}"
  searchdomain = "kevharv.com"
  nameserver   = var.dns_server

  bootdisk = "virtio0"

  # VM Hardware Configuration
  cpu {
    cores   = var.cpus
    sockets = var.sockets
    type    = "host"
  }

  memory = var.memory_mb

  bios = "ovmf"
#   efidisk {
#     efitype = "4m"
#     storage = var.storage_pool
#   }
  boot = "order=virtio0"

  disks {
    ide {
      ide0 {
        cloudinit {
          storage = var.storage_pool
        }
      }
    }
    virtio {
      virtio0 {
        disk {
          size         = var.disk_gb
          cache        = "writeback"
          storage      = var.storage_pool
          iothread     = true
          discard      = true
        }
      }
    }
  }

  network {
    id = 0
    model  = "virtio"
    bridge = var.network_bridge
  }
  skip_ipv6 = true
}

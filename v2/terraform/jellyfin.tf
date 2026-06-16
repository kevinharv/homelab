resource "random_password" "jellyfin_root_password" {
  length           = 32
  override_special = "_%@"
  special          = true
}

resource "proxmox_virtual_environment_container" "jellyfin" {
  description = "Jellyfin personal media server."
  tags        = ["jellyfin", "media"]

  node_name    = var.pve_node
  vm_id        = 1101
  unprivileged = true

  features {
    nesting = true
  }

  initialization {
    hostname = "jellyfin"

    ip_config {
      ipv4 {
        address = "192.168.1.11/24"
        gateway = "192.168.1.254"
      }
    }

    user_account {
      keys     = [file(var.jellyfin_ssh_public_key_path)]
      password = random_password.jellyfin_root_password.result
    }
  }

  network_interface {
    name   = "eth0"
    bridge = "vmbr0"
  }

  wait_for_ip {
    ipv4 = true
  }

  disk {
    datastore_id = "local-lvm"
    size         = 16
  }

  mount_point {
    volume = "tank:vm-115-disk-0"
    path   = "/mnt/media"
  }

  memory {
    dedicated = 4096
    swap      = 1024
  }

  operating_system {
    template_file_id = var.jellyfin_template_file_id
    type             = "ubuntu"
  }

  start_on_boot = true
  startup {
    order      = 10
    up_delay   = 30
    down_delay = 30
  }
}


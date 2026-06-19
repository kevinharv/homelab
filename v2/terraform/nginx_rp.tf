resource "random_password" "nginx_rp_root_password" {
  length           = 32
  override_special = "_%@"
  special          = true
}

resource "proxmox_virtual_environment_container" "nginx_rp" {
  description = "NGINX reverse proxy service for ingress traffic and routing."
  tags        = ["nginx", "ingress"]

  node_name    = var.pve_node
  vm_id        = 1005
  unprivileged = true

  features {
    nesting = true
  }

  initialization {
    hostname = "nginxrp"

    ip_config {
      ipv4 {
        address = "192.168.1.10/24"
        gateway = "192.168.1.254"
      }
    }

    user_account {
      keys     = [file(var.ssh_public_key_path)]
      password = random_password.nginx_rp_root_password.result
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
    size         = 8
  }

  memory {
    dedicated = 1024
    swap      = 1024
  }

  operating_system {
    template_file_id = var.ubuntu_template_file_id
    type             = "ubuntu"
  }

  start_on_boot = true
  startup {
    order      = 5
    up_delay   = 10
    down_delay = 30
  }
}


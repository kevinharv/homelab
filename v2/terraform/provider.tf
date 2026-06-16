provider "proxmox" {
  endpoint = var.pve_host
  username = var.pve_username
  password = var.pve_password
  insecure = !var.pve_verify_tls
}
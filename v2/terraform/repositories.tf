# TODO - import the current subscriptions

# resource "proxmox_apt_standard_repository" "no_sub" {
#   handle = "no-subscription"
#   node   = var.pve_node
# }

# resource "proxmox_apt_repository" "no_sub" {
#   enabled   = true
#   file_path = proxmox_apt_standard_repository.no_sub.file_path
#   index     = proxmox_apt_standard_repository.no_sub.index
#   node      = proxmox_apt_standard_repository.no_sub.node
# }

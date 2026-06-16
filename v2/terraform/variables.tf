/*
    Provider configuration variables.
*/
variable "pve_host" {
  description = "FQDN of the Proxmox API host."
  type        = string
  default     = "https://192.168.1.5:8006/"
}

variable "pve_username" {
  description = "Username of the Proxmox API user."
  type        = string
  default     = "root@pam"
}

variable "pve_password" {
  description = "Password of the Proxmox API user."
  type        = string
  sensitive   = true
}

variable "pve_verify_tls" {
  description = "Whether or not to verify TLS integrity of the connection."
  type        = bool
  default     = false
}

variable "pve_node" {
  description = "Name of the PVE node to target for configuration."
  type        = string
}

/*
    Workload definition variables.
*/

variable "jellyfin_template_file_id" {
  description = "Proxmox template file ID for the Ubuntu 26.04 LXC image."
  type        = string
  default     = "local:vztmpl/ubuntu-26.04-standard_26.04-1_amd64.tar.zst"
}

variable "jellyfin_ssh_public_key_path" {
  description = "Path to the public SSH key used for Jellyfin container root access."
  type        = string
  default     = "/home/kevin/.ssh/prox_lab.pub"
}

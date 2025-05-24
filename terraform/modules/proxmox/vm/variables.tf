/*
    Declare variables required for standard Proxmox VM.
*/

/* Basic VM Configuration */
variable "vmid" {
    description = "Proxmox VM ID"
    type = number
    nullable = true
}

variable "name" {
  description = "Proxmox VM Name"
  type = string
}

variable "description" {
  description = "Proxmox VM Description"
  type = string
}

variable "template_name" {
  description = "Proxmox VM Template Name"
  type = string
}

variable "pve_node" {
  description = "Proxmox VE Node Name"
  type = string
  default = "prox1"
}

variable "vm_state" {
  description = "Proxmox VM Power State"
  type = string
  validation {
    condition = var.vm_state == "running" || var.vm_state == "stopped"
    error_message = "VM power state must 'running' or 'stopped'."
  }
  default = "running"
}

/* Hardware Configuration */
variable "cpus" {
  description = "Proxmox VM vCPU Quantity"
  type = number
  default = 2
}

variable "sockets" {
  description = "Proxmox VM vCPU Socket Quantity"
  type = number
  default = 1
}

variable "memory_mb" {
  description = "Proxmox VM Memory Quantity in Megabytes"
  type = number
  default = 4096
}

variable "storage_pool" {
  description = "Proxmox VM Storage Pool (used for all disks)"
  type = string
  default = "local-lvm"
}

variable "disk_gb" {
  description = "Proxmox VM Disk Size"
  type = number
  default = 30
}

variable "network_bridge" {
  description = "Proxmox VM Network Bridge"
  type = string
  default = "vmbr0"
}

/* Cloud-Init Configuration */
variable "cloud_init_user" {
    description = "Cloud-Init default user username."
    type = string
}

variable "cloud_init_password" {
  description = "Cloud-Init default user password."
  type = string
}

variable "cloud_init_ssh_key" {
    description = "Cloud-Init default user SSH public key."
    type = string
}

variable "vm_cidr" {
  description = "Proxmox VM Primary Interface IP Address (CIDR format)"
  type = string
  validation {
    condition     = can(regex(
      "^((25[0-5]|2[0-4]\\d|[01]?\\d?\\d)\\.){3}(25[0-5]|2[0-4]\\d|[01]?\\d?\\d)/(\\d|[12]\\d|3[0-2])$",
      var.vm_cidr
    ))
    error_message = "IP address must be in CIDR format. (Ex: 10.68.15.0/24)"
  }
}

variable "network_gateway_cidr" {
  description = "Proxmox VM Primary Interface Gateway IP Address (CIDR format)"
  type = string
}

variable "dns_server" {
  description = "Proxmox VM DNS Server IP Address"
  type = string
}
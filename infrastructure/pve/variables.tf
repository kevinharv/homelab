/*
    Top-level variable declarations shared across all Proxmox resources.
*/


/* Authentication Configuration for PVE */

variable "proxmox_hostname" {
    description = "Hostname or IP address of Proxmox VE."
    type = string
}

variable "proxmox_tokenID" {
    description = "Proxmox authentication token ID."
    type = string
    sensitive = true
}

variable "proxmox_token" {
    description = "Proxmox authentication token."
    type = string
    sensitive = true
}
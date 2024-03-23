terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "2.17.0"
    }
  }
}

provider "linode" {
  token = var.linode_token
}

# -------------- Configuration Variables --------------
variable "linode_token" {
  description = "Linode API Access Token"
  type        = string
}

variable "ssh_keys" {
  description = "Default SSH Keys"
  type        = list(string)
}

variable "default_root_password" {
  description = "Default Root Password"
  type        = string
}

variable "power_state" {
  description = "Lab Target Power State"
  type        = bool
  default     = false
}

# -------------- Lab VPC --------------
resource "linode_vpc" "lab-vpc" {
  label       = "lab-vpc"
  region      = "us-ord"
  description = "Lab VPC for private networking."
}

resource "linode_vpc_subnet" "management" {
  vpc_id = linode_vpc.lab-vpc.id
  label  = "management"
  ipv4   = "10.10.1.0/24"
}

resource "linode_vpc_subnet" "kubernetes" {
  vpc_id = linode_vpc.lab-vpc.id
  label  = "kubernetes"
  ipv4   = "10.10.5.0/24"
}

# -------------- WireGuard Firewall --------------
resource "linode_firewall" "wireguard_firewall" {
  label = "wireguard_firewall"

  # TODO - configure firewall for WireGuard service

  # inbound {
  #   label    = "allow-http"
  #   action   = "ACCEPT"
  #   protocol = "TCP"
  #   ports    = "80"
  #   ipv4     = ["0.0.0.0/0"]
  #   ipv6     = ["::/0"]
  # }

  # inbound {
  #   label    = "allow-https"
  #   action   = "ACCEPT"
  #   protocol = "TCP"
  #   ports    = "443"
  #   ipv4     = ["0.0.0.0/0"]
  #   ipv6     = ["::/0"]
  # }

  inbound_policy  = "DROP"
  outbound_policy = "ACCEPT"
}

# -------------- WireGuard VPN Server --------------
resource "linode_instance" "prdwrgd" {
  label       = "PRDWRGD"
  image       = "linode/rocky9"
  region      = "us-ord"
  type        = "g6-nanode-1"
  firewall_id = linode_firewall.wireguard_firewall.id

  booted          = var.power_state
  authorized_keys = var.ssh_keys
  root_pass       = var.default_root_password

  tags = ["wireguard"]

  interface {
    purpose = "public"
  }

  interface {
    purpose   = "vpc"
    subnet_id = linode_vpc_subnet.management.id
    ipv4 {
      vpc = "10.10.1.6"
    }
  }
}
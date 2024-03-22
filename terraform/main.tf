terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "2.17.0"
    }
  }
}

variable "linode_token" {
  description = "Linode API Access Token"
  type        = string
}

provider "linode" {
  token = var.linode_token
}

# -------------- Lab VPC --------------
resource "linode_vpc" "lab-vpc" {
    label = "lab-vpc"
    region = "us-ord"
    description = "Lab VPC for private networking."
}

resource "linode_vpc_subnet" "management" {
    vpc_id = linode_vpc.lab-vpc.id
    label = "management"
    ipv4 = "10.10.1.0/24"
}

resource "linode_vpc_subnet" "kubernetes" {
    vpc_id = linode_vpc.lab-vpc.id
    label = "kubernetes"
    ipv4 = "10.10.8.0/24"
}

# -------------- WireGuard VPN Server --------------
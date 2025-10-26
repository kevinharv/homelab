/*
  Module for <BLANK> resource.
*/


#   100.64.0.0/18	
#     100.64.0.0/20
#     100.64.16.0/20
#     100.64.32.0/20
#   100.64.64.0/18
#     100.64.64.0/20
#     100.64.80.0/20
#     100.64.96.0/20
#   100.64.128.0/18	
#     100.64.128.0/20
#     100.64.144.0/20
#     100.64.160.0/20

# TODO
# - NACLs to permit private <> data; deny rest to data
# - DHCP options + DNS config

data "aws_region" "current_region" {}

resource "aws_vpc" "vpc" {
  cidr_block           = "100.64.0.0/16" # RFC6598 CG-NAT shared IPv4 space
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    "Name" = var.vpc_name
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name" = "${var.vpc_name} IGW"
  }
}

# ====== VPC Route Tables ======

resource "aws_default_route_table" "default_rt" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id

  route = []

  tags = {
    "Name" = "${var.vpc_name} Default Route Table"
  }
}

resource "aws_route_table" "public_subnet_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  route {
    cidr_block = "100.64.0.0/16"
    gateway_id = "local"
  }

  tags = {
    "Name" = "${var.vpc_name} Public Subnet to IGW"
  }
}

resource "aws_route_table" "data_subnet_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "100.64.0.0/16"
    gateway_id = "local"
  }

  tags = {
    "Name" = "${var.vpc_name} Data Subnet RT"
  }
}

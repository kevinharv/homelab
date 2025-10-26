/*
  Module for standard VPC. Provides HA connectivity across 3 subnets
  including a data subnet with access restricted to the private subnet.
*/

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

resource "aws_vpc_dhcp_options" "kevharv_options" {
  domain_name = "aws.kevharv.com"
  domain_name_servers = [ 
    "1.1.1.1",
    "1.0.0.1",
    "8.8.8.8",
    "8.8.4.4"
   ]
  tags = {
    "Name" = "aws.kevharv.com"
  }
}

resource "aws_vpc_dhcp_options_association" "kevharv_options_assoc" {
  dhcp_options_id = aws_vpc_dhcp_options.kevharv_options.id
  vpc_id = aws_vpc.vpc.id
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

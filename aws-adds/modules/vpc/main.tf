/*
    Active Directory Domain Service Lab VPC Configuration
*/

resource "aws_vpc" "adds_lab" {
  cidr_block = "10.100.128.0/17"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = merge(var.default_tags, {
    "Name" = "ADDS-Lab"
  })
}

# VPC Subnets
resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.adds_lab.id
    cidr_block = "10.100.129.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true
    tags = merge(var.default_tags, {
        "Name" = "ADDS-Lab-Public-Subnet"
    })
}

resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.adds_lab.id
    cidr_block = "10.100.130.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = false
    tags = merge(var.default_tags, {
        "Name" = "ADDS-Lab-Private-Subnet"
    })
}

# IGW for Public Subnet
resource "aws_internet_gateway" "lab_igw" {
    vpc_id = aws_vpc.adds_lab.id
    tags = merge(var.default_tags, {
        "Name" = "ADDS-Lab-IGW"
    })
}

# EIP for NAT Gateway
resource "aws_eip" "natgw_eip" {
    domain = "vpc"
    tags = merge(var.default_tags, {
        "Name" = "ADDS-Lab-NATGW-EIP"
    })
}

# NAT Gateway for Private Subnet
resource "aws_nat_gateway" "lab_natgw" {
    allocation_id = aws_eip.natgw_eip.id
    subnet_id = aws_subnet.public_subnet.id
    tags = merge(var.default_tags, {
        "Name" = "ADDS-Lab-NATGW"
    })
}

# Route Tables
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.adds_lab.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lab_igw.id
  }
  tags = merge(var.default_tags, {
    "Name" = "ADDS-Lab-Public-RT"
  })
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.adds_lab.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.lab_natgw.id
  }
  tags = merge(var.default_tags, {
    "Name" = "ADDS-Lab-Private-RT"
  })
}

resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_subnet_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}
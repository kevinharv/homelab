/*
    Entrypoint for "enterprise" foundational infrastructure.
*/

variable "default_tags" {
  description = "Tags applied to all AWS resources."
  type        = map(string)
  default = {
    "ManagedBy"   = "Terraform"
    "Environment" = "Enterprise"
  }
}

# General VPC w/ subnets, IGW?
# General NACLs and security groups?
# IAM identity center?
# Cloudwatch?
# Route53? (probably leave this static configure via UI)
# SES?

resource "aws_vpc" "harvey_lab" {
  cidr_block = "10.100.0.0/16"
  tags = merge(var.default_tags, {
    "Name" = "harvey-lab-vpc"
  })
}

# ========= Public Subnets =========

resource "aws_subnet" "lab_pub_a" {
  vpc_id     = aws_vpc.harvey_lab.id
  cidr_block = "10.100.10.0/24"
  availability_zone = "us-east-2a"
  tags = merge(var.default_tags, {
    "Name" = "lab-pub-a"
  })
}

resource "aws_subnet" "lab_pub_b" {
  vpc_id     = aws_vpc.harvey_lab.id
  cidr_block = "10.100.20.0/24"
  availability_zone = "us-east-2b"
  tags = merge(var.default_tags, {
    "Name" = "lab-pub-b"
  })
}

# ========= Service Subnets =========

resource "aws_subnet" "lab_svc_a" {
  vpc_id     = aws_vpc.harvey_lab.id
  cidr_block = "10.100.12.0/24"
  availability_zone = "us-east-2a"
  tags = merge(var.default_tags, {
    "Name" = "lab-svc-a"
  })
}

resource "aws_subnet" "lab_svc_b" {
  vpc_id     = aws_vpc.harvey_lab.id
  cidr_block = "10.100.22.0/24"
  availability_zone = "us-east-2b"
  tags = merge(var.default_tags, {
    "Name" = "lab-svc-b"
  })
}

# ========= Private Subnets =========

resource "aws_subnet" "lab_prv_a" {
  vpc_id     = aws_vpc.harvey_lab.id
  cidr_block = "10.100.14.0/24"
  availability_zone = "us-east-2a"
  tags = merge(var.default_tags, {
    "Name" = "lab-prv-a"
  })
}

resource "aws_subnet" "lab_prv_b" {
  vpc_id     = aws_vpc.harvey_lab.id
  cidr_block = "10.100.24.0/24"
  availability_zone = "us-east-2b"
  tags = merge(var.default_tags, {
    "Name" = "lab-prv-b"
  })
}

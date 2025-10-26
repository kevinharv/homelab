
# AZ 3 CIDRs
#   100.64.0.0/18	
#     100.64.0.0/20     Public
#     100.64.16.0/20    Private
#     100.64.32.0/20    Data

# ====== AZ A VPC Subnets ======

resource "aws_subnet" "subnet_public_a" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "${data.aws_region.current_region.region}a"
  cidr_block        = "100.64.0.0/20"

  tags = {
    "Name" = "${var.vpc_name} ${data.aws_region.current_region.region}a Public Subnet"
  }
}

resource "aws_subnet" "subnet_private_a" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "${data.aws_region.current_region.region}a"
  cidr_block        = "100.64.16.0/20"

  tags = {
    "Name" = "${var.vpc_name} ${data.aws_region.current_region.region}a Private Subnet"
  }
}

resource "aws_subnet" "subnet_data_a" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "${data.aws_region.current_region.region}a"
  cidr_block        = "100.64.32.0/20"

  tags = {
    "Name" = "${var.vpc_name} ${data.aws_region.current_region.region}a Data Subnet"
  }
}


# ====== AZ A VPC Network Components ======

resource "aws_eip" "natgw_aza_eip" {}

resource "aws_nat_gateway" "natgw_aza" {
  subnet_id     = aws_subnet.subnet_public_a.id
  allocation_id = aws_eip.natgw_aza_eip.id

  tags = {
    "Name" = "${var.vpc_name} ${data.aws_region.current_region.region}a NATGW"
  }
}


# ====== AZ A Route Tables ======

resource "aws_route_table" "private_subnet_rt_a" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw_aza.id
  }

  route {
    cidr_block = "100.64.0.0/16"
    local_gateway_id = "local"
  }

  tags = {
    "Name" = "${var.vpc_name} Private Subnet RT - NATGWA"
  }
}

resource "aws_route_table_association" "public_aza_rt_assoc" {
  route_table_id = aws_route_table.public_subnet_rt.id
  subnet_id = aws_subnet.subnet_public_a.id
}

resource "aws_route_table_association" "private_aza_rt_assoc" {
  route_table_id = aws_route_table.private_subnet_rt_a.id
  subnet_id = aws_subnet.subnet_private_a.id
}

resource "aws_route_table_association" "data_aza_rt_assoc" {
  route_table_id = aws_route_table.data_subnet_rt.id
  subnet_id = aws_subnet.subnet_data_a.id
}

# ====== DATA SUBNET RESTRICTIONS ======

resource "aws_network_acl" "private_data_az1" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    "Name" = "private-data-subnet-traversal-az1"
  }
}

resource "aws_network_acl_rule" "allow_data_from_private_az1" {
  network_acl_id = aws_network_acl.private_data_az1.id
  rule_number = 100
  protocol = "-1"
  rule_action = "allow"
  cidr_block = "100.64.16.0/20"
}

resource "aws_network_acl_rule" "allow_data_to_private_az1" {
  network_acl_id = aws_network_acl.private_data_az1.id
  rule_number = 101
  protocol = "-1"
  rule_action = "allow"
  cidr_block = "100.64.16.0/20"
  egress = true
}

resource "aws_network_acl_association" "data_nacl_assoc_az1" {
  network_acl_id = aws_network_acl.private_data_az1.id
  subnet_id = aws_subnet.subnet_data_a.id
}

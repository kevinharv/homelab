
# AZ 2 CIDRS
#   100.64.64.0/18
#     100.64.64.0/20    Public
#     100.64.80.0/20    Private
#     100.64.96.0/20    Data

# ====== AZ B VPC Subnets ======

resource "aws_subnet" "subnet_public_b" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "${data.aws_region.current_region.region}b"
  cidr_block        = "100.64.64.0/20"

  tags = {
    "Name" = "${var.vpc_name} ${data.aws_region.current_region.region}b Public Subnet"
  }
}

resource "aws_subnet" "subnet_private_b" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "${data.aws_region.current_region.region}b"
  cidr_block        = "100.64.80.0/20"

  tags = {
    "Name" = "${var.vpc_name} ${data.aws_region.current_region.region}b Private Subnet"
  }
}

resource "aws_subnet" "subnet_data_b" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "${data.aws_region.current_region.region}b"
  cidr_block        = "100.64.96.0/20"

  tags = {
    "Name" = "${var.vpc_name} ${data.aws_region.current_region.region}b Data Subnet"
  }
}


# ====== AZ B VPC Network Components ======

resource "aws_eip" "natgw_azb_eip" {}

resource "aws_nat_gateway" "natgw_azb" {
  subnet_id     = aws_subnet.subnet_public_b.id
  allocation_id = aws_eip.natgw_azb_eip.id

  tags = {
    "Name" = "${var.vpc_name} ${data.aws_region.current_region.region}b NATGW"
  }
}

# ====== AZ B Route Tables ======

resource "aws_route_table" "private_subnet_rt_b" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.natgw_azb.id
  }

  route {
    cidr_block = "100.64.0.0/16"
    gateway_id = "local"
  }

  tags = {
    "Name" = "${var.vpc_name} Private Subnet RT - NATGWB"
  }
}

resource "aws_route_table_association" "public_azb_rt_assoc" {
  route_table_id = aws_route_table.public_subnet_rt.id
  subnet_id = aws_subnet.subnet_public_b.id
}

resource "aws_route_table_association" "private_azb_rt_assoc" {
  route_table_id = aws_route_table.private_subnet_rt_b.id
  subnet_id = aws_subnet.subnet_private_b.id
}

resource "aws_route_table_association" "data_azb_rt_assoc" {
  route_table_id = aws_route_table.data_subnet_rt.id
  subnet_id = aws_subnet.subnet_data_b.id
}

# ====== DATA SUBNET RESTRICTIONS ======

resource "aws_network_acl" "private_data_az2" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    "Name" = "private-data-subnet-traversal-az2"
  }
}

resource "aws_network_acl_rule" "allow_data_from_private_az2" {
  network_acl_id = aws_network_acl.private_data_az2.id
  rule_number = 100
  protocol = "-1"
  rule_action = "allow"
  cidr_block = "100.64.80.0/20"
}

resource "aws_network_acl_rule" "allow_data_to_private_az2" {
  network_acl_id = aws_network_acl.private_data_az2.id
  rule_number = 101
  protocol = "-1"
  rule_action = "allow"
  cidr_block = "100.64.80.0/20"
  egress = true
}

resource "aws_network_acl_association" "data_nacl_assoc_az2" {
  network_acl_id = aws_network_acl.private_data_az2.id
  subnet_id = aws_subnet.subnet_data_b.id
}

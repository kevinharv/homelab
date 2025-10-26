
# AZ 3 CIDRs
#   100.64.128.0/18
#     100.64.128.0/20   Public
#     100.64.144.0/20   Private
#     100.64.160.0/20   Data

# ====== AZ B VPC Subnets ======

resource "aws_subnet" "subnet_public_c" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "${data.aws_region.current_region.region}c"
  cidr_block        = "100.64.128.0/20"

  tags = {
    "Name" = "${var.vpc_name} ${data.aws_region.current_region.region}c Public Subnet"
  }
}

resource "aws_subnet" "subnet_private_c" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "${data.aws_region.current_region.region}c"
  cidr_block        = "100.64.144.0/20"

  tags = {
    "Name" = "${var.vpc_name} ${data.aws_region.current_region.region}c Private Subnet"
  }
}

resource "aws_subnet" "subnet_data_c" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "${data.aws_region.current_region.region}c"
  cidr_block        = "100.64.160.0/20"

  tags = {
    "Name" = "${var.vpc_name} ${data.aws_region.current_region.region}c Data Subnet"
  }
}

# ====== AZ C Route Tables ======

resource "aws_route_table_association" "public_azc_rt_assoc" {
  route_table_id = aws_route_table.public_subnet_rt.id
  subnet_id = aws_subnet.subnet_public_c.id
}

resource "aws_route_table_association" "private_azc_rt_assoc" {
  route_table_id = aws_route_table.private_subnet_rt_b.id
  subnet_id = aws_subnet.subnet_private_c.id
}

resource "aws_route_table_association" "data_azc_rt_assoc" {
  route_table_id = aws_route_table.data_subnet_rt.id
  subnet_id = aws_subnet.subnet_data_c.id
}

# ====== DATA SUBNET RESTRICTIONS ======

resource "aws_network_acl" "private_data_az3" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    "Name" = "private-data-subnet-traversal-az3"
  }
}

resource "aws_network_acl_rule" "allow_data_from_private_az3" {
  network_acl_id = aws_network_acl.private_data_az3.id
  rule_number = 100
  protocol = "-1"
  rule_action = "allow"
  cidr_block = "100.64.144.0/20"
}

resource "aws_network_acl_rule" "allow_data_to_private_az3" {
  network_acl_id = aws_network_acl.private_data_az3.id
  rule_number = 101
  protocol = "-1"
  rule_action = "allow"
  cidr_block = "100.64.144.0/20"
  egress = true
}

resource "aws_network_acl_association" "data_nacl_assoc_az3" {
  network_acl_id = aws_network_acl.private_data_az3.id
  subnet_id = aws_subnet.subnet_data_c.id
}


#   100.64.0.0/18	
#     100.64.0.0/20
#     100.64.16.0/20
#     100.64.32.0/20

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
    gateway_id = aws_nat_gateway.natgw_aza.id
  }

  route {
    cidr_block = "100.64.0.0/16"
    gateway_id = "local"
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


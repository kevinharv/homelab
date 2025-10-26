
#   100.64.128.0/18	
#     100.64.128.0/20
#     100.64.144.0/20
#     100.64.160.0/20

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

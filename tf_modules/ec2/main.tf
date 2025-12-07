/*
  Module for basic EC2 resource.
*/

data "aws_subnet" "vpc_subnet" {
  id = var.subnet_id
}

resource "aws_instance" "instance" {
  instance_type     = var.instance_type
  ami               = var.ami
  availability_zone = data.aws_subnet.vpc_subnet.availability_zone
  subnet_id         = var.subnet_id
  key_name          = var.key_name

  user_data = var.user_data

  vpc_security_group_ids = [
    aws_security_group.allow_egress.id,
  ]

  tags = {
    "Name" = var.hostname
  }
}

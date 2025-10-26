/*
  Outputs from <BLANK> module.
*/

output "vpc_id" {
  value = aws_vpc.vpc.id
}

# PUBLIC SUBNETS
output "public_subnet_a_id" {
  value = aws_subnet.subnet_public_a.id
}

output "public_subnet_b_id" {
  value = aws_subnet.subnet_public_b.id
}

output "public_subnet_c_id" {
  value = aws_subnet.subnet_public_c.id
}

# PRIVATE SUBNETS
output "private_subnet_a_id" {
  value = aws_subnet.subnet_private_a.id
}

output "private_subnet_b_id" {
  value = aws_subnet.subnet_private_b.id
}

output "private_subnet_c_id" {
  value = aws_subnet.subnet_private_c.id
}

# DATA SUBNETS
output "data_subnet_a_id" {
  value = aws_subnet.subnet_data_a.id
}

output "data_subnet_b_id" {
  value = aws_subnet.subnet_data_b.id
}

output "data_subnet_c_id" {
  value = aws_subnet.subnet_data_c.id
}

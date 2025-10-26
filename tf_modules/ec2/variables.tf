/*
    Variables for <BLANK> module.
*/

variable "vpc_id" {
  description = "VPC ID for security rules to apply to."
}

variable "subnet_id" {
  description = "Subnet ID for the instance to reside in."
}

variable "hostname" {
  description = "Hostname for the instance."
}

variable "instance_type" {
  description = "AWS EC2 instance type to create."
  type = string
  default = "m8g.large"
}

variable "ami" {
  description = "AMI to launch the EC2 instance with."
  type = string
  default = "ami-0aedd279d804f4e96"   # Rocky 10
}

variable "key_name" {
  description = "EC2 key pair name to create the instance with."
  type = string
}

variable "user_data" {
  description = "EC2 user data to start the instance with."
  type = string
}

/*
    Top-level variable declaration for all AWS resources.
*/

variable "aws_region" {
    description = "AWS region to deploy resources in."
    type = string
    default = "us-east-1"
}

variable "aws_access_key" {
    description = "AWS IAM access key."
    type = string
    sensitive = true
}

variable "aws_secret_key" {
    description = "AWS IAM secret key."
    type = string
    sensitive = true
}

variable "ts_auth_key" {
  description = "Tailscale Authentication Key"
  type        = string
  sensitive   = true
}

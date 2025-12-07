
# Candidate general-purpose arm64 instance types constrained to <=4 vCPU and <=16GiB RAM
locals {
  candidate_instance_types = [
    "t4g.micro",
    "t4g.small",
    "t4g.medium",
    "t4g.large",
    "t4g.xlarge",
    "m6g.medium",
    "m6g.large",
    "m6g.xlarge",
  ]
}

data "aws_ec2_instance_type_offerings" "available_candidates" {
  location_type = "region"

  filter {
    name   = "location"
    values = [data.aws_region.current.region]
  }

  filter {
    name   = "instance-type"
    values = local.candidate_instance_types
  }
}

resource "aws_iam_instance_profile" "image_factory_instance_profile" {
  name = "${var.resource_prefix}-image-factory-role"
  role = "EC2InstanceProfileForImageBuilder"
}

resource "aws_imagebuilder_infrastructure_configuration" "infra_config" {
  name                          = "${var.resource_prefix}-infrastructure-config"
  instance_profile_name         = aws_iam_instance_profile.image_factory_instance_profile.name
  description                   = "Infrastructure Configuration for Image Factory"
  terminate_instance_on_failure = true
  instance_types                = data.aws_ec2_instance_type_offerings.available_candidates.instance_types
}

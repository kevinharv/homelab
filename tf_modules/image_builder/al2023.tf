
data "aws_ami" "latest_al2023_upstream" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-*-arm64*"]
  }

  filter {
    name   = "architecture"
    values = ["arm64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

resource "aws_imagebuilder_image_recipe" "al2023_recipe" {
  name        = "${var.resource_prefix}-AL2023"
  description = "Amazon Linux 2023 KMH Base Image"
  version     = "0.1.0"

  parent_image = data.aws_ami.latest_al2023_upstream.id

  component {
    component_arn = aws_imagebuilder_component.patch_component.arn
  }

  ami_tags = {
    "KMH:CreatedBy" = "Kevin"
  }

  tags = {
    "KMH:Name" = "${var.resource_prefix}-AL2023"
  }
}

resource "aws_imagebuilder_image_pipeline" "al2023_pipeline" {
  name                             = "${var.resource_prefix}-AL2023-pipeline"
  image_recipe_arn                 = aws_imagebuilder_image_recipe.al2023_recipe.arn
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.infra_config.arn

  lifecycle {
    replace_triggered_by = [aws_imagebuilder_image_recipe.al2023_recipe]
  }

  tags = {
    "KMH:Name" = "${var.resource_prefix}-AL2023-pipeline"
  }
}

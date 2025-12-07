
resource "aws_iam_role" "image_factory_lifecycle_role" {
  name = "${var.resource_prefix}-ImageFactoryLifecycleRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "imagebuilder.${data.aws_partition.current.dns_suffix}"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "attach_lifecycle_role_policy" {
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/EC2ImageBuilderLifecycleExecutionPolicy"
  role       = aws_iam_role.image_factory_lifecycle_role.name
}

resource "aws_imagebuilder_lifecycle_policy" "retain_7_days" {
  name           = "${var.resource_prefix}-retain-7-days"
  description    = "Retain old images for only 7 days."
  execution_role = aws_iam_role.image_factory_lifecycle_role.arn
  resource_type  = "AMI_IMAGE"

  policy_detail {
    action {
      type = "DEPRECATE"
    }
    filter {
      type            = "AGE"
      value           = 30
      retain_at_least = 1
      unit            = "DAYS"
    }
  }

  policy_detail {
    action {
      type = "DISABLE"
    }
    filter {
      type            = "AGE"
      value           = 60
      retain_at_least = 1
      unit            = "DAYS"
    }
  }

  policy_detail {
    action {
      type = "DELETE"
    }
    filter {
      type            = "AGE"
      value           = 90
      retain_at_least = 1
      unit            = "DAYS"
    }
  }

  resource_selection {
    tag_map = {
      "KMH:CreatedBy" = "Kevin"
    }
  }

  depends_on = [aws_iam_role_policy_attachment.attach_lifecycle_role_policy]
}

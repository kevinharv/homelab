/*
    Entrypoint for "enterprise" foundational infrastructure.
*/

variable "default_tags" {
  description = "Tags applied to all AWS resources."
  type        = map(string)
  default = {
    "Project"   = "CIS Hardening Lab"
    "ManagedBy" = "Terraform"
  }
}

module "vpc" {
  source = "./modules/vpc"
  default_tags = var.default_tags
}

resource "aws_security_group" "allow_egress" {
  name = "allow-egress"
  vpc_id = module.vpc.vpc_id
  egress {
    to_port = 0
    from_port = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all egress."
  }
  tags = merge(var.default_tags, {
    "Name" = "allow-egress"
  })
}

resource "aws_security_group" "allow_egress_2" {
  name = "allow-egress"
  egress {
    to_port = 0
    from_port = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all egress."
  }
  tags = merge(var.default_tags, {
    "Name" = "allow-egress"
  })
}

resource "aws_security_group" "allow_ssh" {
  name = "allow-ssh"
  ingress {
    to_port = 22
    from_port = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all SSH."
  }
  tags = merge(var.default_tags, {
    "Name" = "allow-ssh"
  })
}

resource "aws_ec2_instance_state" "awslbench001_state" {
  instance_id = aws_instance.awslbench001.id
  state = "stopped"
}

resource "aws_instance" "awslbench001" {
  instance_type     = "m8g.large"
  ami               = "ami-0aedd279d804f4e96"
  availability_zone = "us-east-1a"
  subnet_id         = module.vpc.private_subnet_id

  # associate_public_ip_address = true

  key_name = "aws_lab"

  user_data = <<-EOF
      #!/bin/bash
      sudo hostname awslbench001
      sudo dnf config-manager --add-repo https://pkgs.tailscale.com/stable/rhel/10/tailscale.repo
      sudo dnf install tailscale -y
      sudo systemctl enable --now tailscaled
      export TS_HOSTNAME="awslbench001"
      export TS_AUTHKEY="${var.ts_auth_key}"
      sudo tailscale up --auth-key=$TS_AUTHKEY --hostname=$TS_HOSTNAME
    EOF

  vpc_security_group_ids = [
    aws_security_group.allow_egress.id,
  ]

  # security_groups = [ aws_security_group.allow_ssh.name, aws_security_group.allow_egress_2.name ]

  tags = merge(var.default_tags, {
    "Name" = "awslbench001"
  })
}

# resource "aws_route53_record" "vm_dns" {
#   name    = "awslbench001.aws.kevharv.com"
#   zone_id = "Z00415283KPF7VLVK1YLX"
#   type    = "A"
#   ttl     = 300
#   records = [aws_instance.awslbench001.public_ip]
# }

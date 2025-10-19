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

resource "aws_instance" "awslbench001" {
  instance_type     = "m8g.large"
  ami               = "ami-0aedd279d804f4e96"
  availability_zone = "us-east-1a"
  # subnet_id         = module.vpc.private_subnet_id

  associate_public_ip_address = true

  key_name = "aws_lab"

  user_data = <<-EOF
      #!/bin/bash
      sudo dnf config-manager --add-repo https://pkgs.tailscale.com/stable/rhel/9/tailscale.repo
      sudo dnf install tailscale
      sudo systemctl enable --now tailscaled
      export TS_HOSTNAME="awslbench001"
      export TS_AUTHKEY="tskey-auth-kZDKda1AEE11CNTRL-pMvCdRoatsKZjw6byk8TsKzALZ4dtTdo7"
      tailscale up --auth-key=tskey-auth-kZDKda1AEE11CNTRL-pMvCdRoatsKZjw6byk8TsKzALZ4dtTdo7 --hostname=awslbench001
    EOF

  # vpc_security_group_ids = [
  #   aws_security_group.allow_egress.id,
  # ]

  security_groups = [ aws_security_group.allow_ssh.name ]

  tags = merge(var.default_tags, {
    "Name" = "awslbench001"
  })
}

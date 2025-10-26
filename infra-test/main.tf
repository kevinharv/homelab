/*
    Entrypoint for "enterprise" foundational infrastructure.
*/

module "vpc" {
  source   = "../tf_modules/vpc"
  vpc_name = "KMH-Lab"
}

data "aws_ami" "rocky-10-ami" {
  most_recent      = true
  owners           = ["679593333241"]   # Rocky Linux Foundation

  filter {
    name   = "name"
    values = ["Rocky-10-EC2-Base-10*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

module "ec2" {
  source = "../tf_modules/ec2"

  hostname = "awsltest001"
  ami = data.aws_ami.rocky-10-ami.id
  vpc_id = module.vpc.vpc_id
  subnet_id = module.vpc.private_subnet_a_id
  key_name = "aws_lab"
  user_data = <<-EOF
      #!/bin/bash
      sudo hostnamectl set-hostname awsltest001
      sudo dnf config-manager --add-repo https://pkgs.tailscale.com/stable/rhel/10/tailscale.repo
      sudo dnf install tailscale -y
      sudo systemctl enable --now tailscaled
      export TS_HOSTNAME="awsltest001"
      export TS_AUTHKEY="${var.ts_auth_key}"
      sudo tailscale up --auth-key=$TS_AUTHKEY --hostname=$TS_HOSTNAME
    EOF
}
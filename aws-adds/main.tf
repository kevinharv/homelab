/*
    Entrypoint for "enterprise" foundational infrastructure.
*/

variable "default_tags" {
  description = "Tags applied to all AWS resources."
  type        = map(string)
  default = {
    "Project"   = "AD DS Lab"
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

resource "aws_instance" "AWSADDSDC001" {
  instance_type     = "t3.small"
  ami               = "ami-0efee5160a1079475"
  availability_zone = "us-east-1a"
  subnet_id         = module.vpc.private_subnet_id

  get_password_data           = true
  associate_public_ip_address = false

  key_name = "ADDS-KeyPair"

  user_data = <<-EOF
      <powershell>
      # Configure AWS NTP
      w32tm /config /manualpeerlist:169.254.169.123 /syncfromflags:manual /update

      # Download and install Tailscale
      $tailscaleInstaller = "https://pkgs.tailscale.com/stable/tailscale-setup-latest-amd64.msi"
      $installerPath = "$env:TEMP\tailscale-setup-latest-amd64.msi"
      Invoke-WebRequest -Uri $tailscaleInstaller -OutFile $installerPath
      Start-Process msiexec.exe -Wait -ArgumentList "/i $installerPath /qn"

      # Start Tailscale and join Tailnet (replace AUTH_KEY with your actual key)
      $authKey = "tskey-auth-kZDKda1AEE11CNTRL-pMvCdRoatsKZjw6byk8TsKzALZ4dtTdo7"
      & 'C:\Program Files\Tailscale\tailscale.exe' up --auth-key $authKey --hostname AWSADDSDC001 --unattended
      </powershell>
    EOF

  vpc_security_group_ids = [
    aws_security_group.allow_egress.id
  ]

  tags = merge(var.default_tags, {
    "Name" = "AWSADDSDC001"
  })
}

output "AWSADDSDC001_password" {
  description = "Administrator password for AWSADDSDC001."
  value       = rsadecrypt(aws_instance.AWSADDSDC001.password_data, file("./ADDS-KeyPair.pem"))
}

# ========= Supporting Services =========

# Setup user-data to install Tailscale and join the tailnet?

# NLB
# Monitoring
# Additional SSM configs?
# AWS AD Directory Config?

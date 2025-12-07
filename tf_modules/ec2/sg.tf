
resource "aws_security_group" "allow_egress" {
  name   = "allow-egress"
  vpc_id = var.vpc_id
  egress {
    to_port     = 0
    from_port   = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all egress traffic."
  }
}

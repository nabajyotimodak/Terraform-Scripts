# Launching an EC2 Instance

resource "aws_instance" "MyEC2_Terraform" {
  ami                         = "ami-0b0dcb5067f052a63"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name                    = "EKS-Keypair"
  tags = {
    "Env" = "Dev"
    "Utility" = "Testing Terraform"
  }
}



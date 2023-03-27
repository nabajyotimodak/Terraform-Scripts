resource "aws_instance" "public1" {
  ami                         = var.amipub
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.pubsub1.id
  associate_public_ip_address = true
  security_groups             = [aws_security_group.pubSG1.id]
  user_data                   = file("user1.sh")

  tags = {
    Name = "PUB-INSTANCE-1"
  }
}
resource "aws_instance" "public2" {
  ami                         = var.amipub
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.pubsub2.id
  associate_public_ip_address = true
  security_groups             = [aws_security_group.pubSG1.id]
  user_data                   = file("user1.sh")

  tags = {
    Name = "PUB-INSTANCE-2"
  }
}
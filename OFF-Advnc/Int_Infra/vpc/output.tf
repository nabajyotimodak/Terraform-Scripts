output "vpc_id" {
  value       = aws_vpc.this.id
  description = "ID of the VPC"
}

output "private_subnet" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.private-subnet.id
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.public-subnet-1.id
}

output "default_sg"{
    description = "Default sg of the VPC"
    value       = aws_security_group.this.id
}
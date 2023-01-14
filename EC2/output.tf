# Define Output Values

output "ec2_arn" {
  value       = aws_instance.MyEC2_Terraform.arn
  description = "ARN of the instance"
}

output "public_ip" {
  value       = aws_instance.MyEC2_Terraform.public_ip
  description = "Details of public_ip"
}

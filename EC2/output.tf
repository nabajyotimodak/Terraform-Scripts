# Define Output Values

output "endpoint" {
  value       = aws_instance.MyEC2_Terraform.arn
  description = "ARN of the instance"
}

output "endpoint" {
  value       = aws_instance.MyEC2_Terraform.public_ip
  description = "Detaild of the arn of the instance"
}

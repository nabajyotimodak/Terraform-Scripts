# Define Output Values

output "endpoint" {
  value       = aws_instance.MyEC2_Terraform.arn
  description = "Detaild of the arn of the instance"
}

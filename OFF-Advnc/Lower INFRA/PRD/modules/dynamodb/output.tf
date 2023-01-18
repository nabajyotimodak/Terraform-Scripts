output "table_arn" {
  value       = aws_dynamodb_table.this.arn
  description = "The ARN of the Dynamo DB table"
}
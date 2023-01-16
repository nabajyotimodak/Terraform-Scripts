output "lambda_execution_role" {
  value       = aws_iam_role.lambda_execution_role.arn
  description = "The ARN of the lambda execution role"
}

output "eventbridge_exec_role" {
  value       = aws_iam_role.eventbridge_exec_role.arn
  description = "The ARN of the eventbridge execution role"
}

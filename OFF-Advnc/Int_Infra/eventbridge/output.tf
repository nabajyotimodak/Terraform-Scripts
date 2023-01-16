output "lambda_ping_schedule" {
  value       = aws_scheduler_schedule.lambda_ping_schedule.arn
  description = "The ARN of the lambda ping schedule"
}
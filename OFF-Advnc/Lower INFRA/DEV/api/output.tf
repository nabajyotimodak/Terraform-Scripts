output "api_gateway_arn" {
  value = aws_api_gateway_rest_api.this.arn
}

output "api_gateway_exec_arn" {
  value = aws_api_gateway_rest_api.this.execution_arn
}
##############################################################
# Define Output Values
##############################################################


output "ec2_arn" {
  description = "ARN of the instance"
  value       = aws_instance.chatbot_ec2.arn
}

output "alb_dns" {
  description = "DNS name of the ALB"
  value       = aws_lb.alb_chatbot.dns_name
}

output "sns_1_arn" {
  description = "ARN of the 1st SNS Topic"
  value = aws_sns_topic.sns_topic_trigger.arn
}

output "sns_2_arn" {
  description = "ARN of the 2nd SNS Topic"
  value = aws_sns_topic.sns_topic_notification.arn
}

output "lambda_arn" {
  description = "ARN of the lambda function created for indentifying the umhealthy target"
  value = aws_lambda_function.test_lambda.arn
}
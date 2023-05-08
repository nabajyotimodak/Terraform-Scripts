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
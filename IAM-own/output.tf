# Define Output Values

output "aws_iam_role" {
  description = "The role creation arn & name"
  value       = [aws_iam_role.lambda_execution_role.arn, aws_iam_role.lambda_execution_role.name]
}

output "aws_iam_role_policy_attachment_SecretsManagerReadWrite" {
  description = "The policy attachment"
  value       = aws_iam_role_policy_attachment.SecretsManagerReadWrite_attach.role
}

output "aws_iam_role_policy_attachment_AmazonDynamoDBFullAccess" {
  description = "The policy attachment"
  value       = aws_iam_role_policy_attachment.AmazonDynamoDBFullAccess_attach.role
}

output "aws_iam_role_policy_attachment_AWSXRayDaemonWriteAccess" {
  description = "The policy attachment"
  value       = aws_iam_role_policy_attachment.AWSXRayDaemonWriteAccess_attach.role
}

output "aws_iam_role_policy_attachment_AWSLambdaDynamoDBExecutionRole" {
  description = "The policy attachment"
  value       = aws_iam_role_policy_attachment.AWSLambdaDynamoDBExecutionRole_attach.role
}

output "aws_iam_role_policy_attachment_AWSLambdaVPCAccessExecutionRole" {
  description = "The policy attachment"
  value       = aws_iam_role_policy_attachment.AWSLambdaVPCAccessExecutionRole_attach.role
}

output "aws_iam_role_policy_attachment_AWSLambdaRole" {
  description = "The policy attachment"
  value       = aws_iam_role_policy_attachment.AWSLambdaRole_attach.role
}

# Define Output Values

output "aws_iam_role" {
  description = "The role creation ARN"
  value       = aws_iam_role.EventBridge_Schedular_execution_Role2.arn
}

output "aws_iam_role_policy" {
  description = "The policy creation ARN"
  value       = aws_iam_role_policy.EventBridge_Schedular_Policy.id
}
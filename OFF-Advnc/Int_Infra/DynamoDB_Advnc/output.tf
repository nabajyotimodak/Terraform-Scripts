output "ReadingList" {
  value       = module.ReadingList.table_arn
  description = "The ARN of the Dynamo DB table - ReadingList"
}

output "InterestsTopics" {
  value       = module.InterestsTopics.table_arn
  description = "The ARN of the Dynamo DB table - Interests"
}

output "InterestsSectors" {
  value       = module.InterestsSectors.table_arn
  description = "The ARN of the Dynamo DB table - Interests"
}

output "LikesDislikes" {
  value       = module.LikesDislikes.table_arn
  description = "The ARN of the Dynamo DB table - LikesDislikes"
}

output "MeteredReading" {
  value       = module.MeteredReading.table_arn
  description = "The ARN of the Dynamo DB table - MeteredReading"
}

output "EmailTemplates" {
  value       = module.EmailTemplates.table_arn
  description = "The ARN of the Dynamo DB table - EmailTemplates"
}

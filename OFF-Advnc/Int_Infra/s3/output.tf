output "artifact_bucket_id" {
  description = "ID of the S3 bucket"

  value = module.lambda_artifact_bucket.s3_bucket_id
}

output "artifact_bucket_arn" {
  description = "ARN of the S3 bucket"

  value = module.lambda_artifact_bucket.s3_bucket_arn
}
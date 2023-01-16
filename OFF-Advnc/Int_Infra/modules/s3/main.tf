# ------------------------------------------------------------------------------
# CREATE AN S3 BUCKET AND DYNAMODB TABLE TO USE AS A TERRAFORM BACKEND
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# CREATE THE S3 BUCKET
# ------------------------------------------------------------------------------

resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name

  # versioning {
  #   enabled = true
  # }

  # Enable server-side encryption by default
  # server_side_encryption_configuration {
  #   rule {
  #     apply_server_side_encryption_by_default {
  #       kms_master_key_id = var.kms_master_key_arn != "" ? var.kms_master_key_arn : null
  #       sse_algorithm = var.kms_master_key_arn != "" ? "aws:kms" : "AES256"
  #     }
  #   }
  # }

  tags = merge(var.tags, {
    Terraform = true
    Project = "DAG"
  })
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "force_ssl_access" {
  bucket = aws_s3_bucket.this.id

  policy = var.aws_s3_bucket_policy != "" ? var.aws_s3_bucket_policy : <<POLICY
{
  "Version": "2012-10-17",
  "Id": "Require_SSL-${var.bucket_name}",
  "Statement": [
    {
      "Sid": "IPAllow",
      "Effect": "Deny",
      "Principal": "*",
      "Action":"s3:GetObject",
      "Resource":"arn:aws:s3:::${var.bucket_name}/*",
      "Condition":{
          "Bool":{
            "aws:SecureTransport":"false"
          }
      }
    }
  ]
}
  POLICY
}
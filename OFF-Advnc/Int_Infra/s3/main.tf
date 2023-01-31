provider "aws" {
  region = "us-east-1"
}

module "lambda_artifact_bucket" {
  source  = "../modules/s3"
  bucket_name = "integration-layer-artifacts"
}

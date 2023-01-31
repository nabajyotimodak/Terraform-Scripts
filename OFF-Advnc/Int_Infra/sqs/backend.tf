terraform {
  backend "s3" {
    bucket = "integration-layer-state"

    key = "sqs.tfstate"

    encrypt        = "true"
    region         = "us-east-1"
  }
}
terraform {
  backend "s3" {
    bucket = "integration-layer-state"

    key = "stg/eventbridge.tfstate"

    encrypt        = "true"
    region         = "us-east-1"
  }
}
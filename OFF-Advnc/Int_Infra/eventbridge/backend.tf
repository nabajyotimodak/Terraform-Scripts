terraform {
  backend "s3" {
    bucket = "integration-layer-state"

    key = "eventbridge.tfstate"

    encrypt        = "true"
    region         = "us-east-1"
  }
}
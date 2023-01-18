terraform {
  backend "s3" {
    bucket = "integration-layer-state"

    key = "dev/eventbridge.tfstate"

    encrypt        = "true"
    region         = "us-east-1"
  }
}
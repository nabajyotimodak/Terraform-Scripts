terraform {
  backend "s3" {
    bucket = "integration-layer-state"

    key = "s3.tfstate"

    encrypt        = "true"
    region         = "us-east-1"
  }
}
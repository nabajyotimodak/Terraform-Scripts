terraform {
  backend "s3" {
    bucket = "integration-layer-state"

    key = "vpc.tfstate"

    encrypt        = "true"
    region         = "us-east-1"
  }
}

terraform {
  backend "s3" {
    bucket = "integration-layer-state"

    key = "dev/dynamoDB.tfstate"

    encrypt        = "true"
    region         = "us-east-1"
  }
}
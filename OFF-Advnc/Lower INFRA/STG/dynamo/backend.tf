terraform {
  backend "s3" {
    bucket = "integration-layer-state-stg"

    key = "stg/dynamoDB.tfstate"

    encrypt        = "true"
    region         = "us-east-1"
  }
}
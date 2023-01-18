terraform {
  backend "s3" {
    bucket = "integration-layer-state-stg"

    key = "prd/dynamoDB.tfstate"

    encrypt        = "true"
    region         = "us-east-1"
  }
}
terraform {
  backend "s3" {
    bucket = "integration-layer-state"

    key = "prd/api.tfstate"

    encrypt        = "true"
    region         = "us-east-1"
  }
}

data "terraform_remote_state" "utilities_lambda" {
  backend = "s3"
  config = {
    bucket = "integration-layer-state"
    key    = "prd/lambda/utilities.tfstate"
    region = "us-east-1"
    acl = "bucket-owner-full-control"
  }
}

data "terraform_remote_state" "user_management_lambda" {
  backend = "s3"
  config = {
    bucket = "integration-layer-state"
    key    = "lambda/user_management.tfstate"
    region = "us-east-1"
    acl = "bucket-owner-full-control"
  }
}

data "terraform_remote_state" "user_preferences_lambda" {
  backend = "s3"
  config = {
    bucket = "integration-layer-state"
    key    = "lambda/user_preferences.tfstate"
    region = "us-east-1"
    acl = "bucket-owner-full-control"
  }
}
## Backend syntax
/*
terraform {
  backend "s3" {
    bucket = "terraform-backend-naba"

    key = "iam.tfstate"

    encrypt = "true"
    region  = "us-east-2"
  }
}

*/
terraform {
  backend "s3" {
    bucket = "terraform-backend-naba"

    key = "eks.tfstate"

    encrypt = "true"
    region  = "us-east-2"
  }
}


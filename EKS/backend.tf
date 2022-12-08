terraform {
  backend "s3" {
    bucket = "chatbot-eks"

    key = "eks.tfstate"

    encrypt = "true"
    region  = "us-east-1"
  }
}


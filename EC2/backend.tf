terraform {
  backend "s3" {
    bucket = "chatbot-eks"

    key = "ec2.tfstate"

    encrypt = "true"
    region  = "us-east-1"
  }
}


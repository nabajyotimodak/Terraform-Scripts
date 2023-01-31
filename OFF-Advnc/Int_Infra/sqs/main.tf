provider "aws" {
  region = "us-east-1"
}

module "sqs_queue" {
  source  = "../modules/sqs"
  name = "UpdateMeteredReading.fifo"

  tags = {
    Service     = "user"
    Environment = "dev"
  }
}



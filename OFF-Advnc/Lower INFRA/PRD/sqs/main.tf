/*
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.44.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.2.0"
    }
  }

  required_version = "~> 1.0"
} */

provider "aws" {
  region = "us-east-1"
}

variable "env" {
  description = "Env for sqs (dev, stg, prod)"
  type = string
  default = "PRD"
}

module "sqs_queue" {
  source  = "../modules/sqs"
  name = "UpdateMeteredReading.fifo"
  env = var.env
  tags = {
    Service     = "user"
    Environment = "PRD"
  }
}



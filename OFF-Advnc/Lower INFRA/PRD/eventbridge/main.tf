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

data "terraform_remote_state" "utilities_lambda" {
  backend = "s3"
  config = {
    bucket = "integration-layer-state"
    key    = "prd/lambda/utilities.tfstate"
    region = "us-east-1"
    acl = "bucket-owner-full-control"
  }
}

data "terraform_remote_state" "iam" {
  backend = "s3"
  config = {
    bucket = "integration-layer-state"
    key    = "iam.tfstate"
    region = "us-east-1"
    acl = "bucket-owner-full-control"
  }
}

resource "aws_scheduler_schedule" "CreateTablePingSchedule" {
  name       = "CreateMeteredReadingTableSchedule-PRD"

  flexible_time_window {
    mode = "OFF"
  }

  schedule_expression = "cron(45 23 L * ? *)"

  target {
    arn      = data.terraform_remote_state.utilities_lambda.outputs.Util-CreateMeteredReadingTable-DB-Lambda-Arn
    role_arn = data.terraform_remote_state.iam.outputs.eventbridge_exec_role
    input = jsonencode({})
  }
}

resource "aws_scheduler_schedule" "DeleteTablePingSchedule" {
  name       = "DeleteMeteredReadingTableSchedule-PRD"

  flexible_time_window {
    mode = "OFF"
  }

  schedule_expression = "cron(15 0 1 * ? *)"

  target {
    arn      = data.terraform_remote_state.utilities_lambda.outputs.Util-DeleteMeteredReadingTable-DB-Lambda-Arn
    role_arn = data.terraform_remote_state.iam.outputs.eventbridge_exec_role
    input = jsonencode({})
  }
}
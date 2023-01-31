data "terraform_remote_state" "utilities_lambda" {
  backend = "s3"
  config = {
    bucket = "integration-layer-state"
    key    = "prd/lambda/utilities.tfstate"
    region = "us-east-1"
    acl = "bucket-owner-full-control"
  }
}

resource "aws_sqs_queue" "terraform_queue" {
  name                      = var.name
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
  visibility_timeout_seconds = 100
  fifo_queue                  = true
  content_based_deduplication = true

  tags = var.tags
}

resource "aws_lambda_event_source_mapping" "example" {
  event_source_arn = aws_sqs_queue.terraform_queue.arn
  function_name    = data.terraform_remote_state.utilities_lambda.outputs.Util-UpdateMeteredReading-DB-Lambda-Arn
}


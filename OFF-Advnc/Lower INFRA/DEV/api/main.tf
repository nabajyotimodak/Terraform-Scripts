provider "aws" {
  region = "us-east-1"
}

locals {
    api_name = "Integration API"
    api_description = "This is the set of API endpoints for Advisory Board AWS integration"
    api_key = "key"

    # paths = {
    #   "/testpath" = {
    #     post = {
    #       x-amazon-apigateway-integration = {
    #         httpMethod           = "POST"
    #         payloadFormatVersion = "1.0"
    #         type                 = "AWS_PROXY"
    #         uri                  = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/${data.terraform_remote_state.utilities_lambda.outputs.Util-TestAPI-Lambda-Arn}/invocations"
    #       }
    #     }
    #   },
    #   "/path2" = {
    #     post = {
    #       x-amazon-apigateway-integration = {
    #         httpMethod           = "POST"
    #         payloadFormatVersion = "1.0"
    #         type                 = "AWS_PROXY"
    #         uri                  = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/${data.terraform_remote_state.utilities_lambda.outputs.Util-OktaInvoke-OK-Lambda-Arn}/invocations"
    #       }
    #     }
    #   }
    #   "/path3" = {
    #     post = {
    #       x-amazon-apigateway-integration = {
    #         httpMethod           = "POST"
    #         payloadFormatVersion = "1.0"
    #         type                 = "AWS_PROXY"
    #         uri                  = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/${module.Util-OktaInvoke-OK-Lambda.function_arn}/invocations"
    #       }
    #     }
    #   }
    # }
}

resource "aws_api_gateway_rest_api" "this" {
  name           = local.api_name
  description    = local.api_description
  
  api_key_source = "HEADER"
  
  body = file("${path.module}/api.json")

  endpoint_configuration {
    types = ["REGIONAL"]
  }

#   body = jsonencode({
#     openapi = "3.0.1"
#     info = {
#       title   = "example"
#       version = "1.0"
#     }
#     paths = local.paths
#   })

#   endpoint_configuration {
#     types = ["REGIONAL"]
#   }
}

resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.this.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_method_settings" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  stage_name  = aws_api_gateway_stage.this.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = true
    logging_level   = "INFO"
  }
}

resource "aws_api_gateway_stage" "this" {
  deployment_id = aws_api_gateway_deployment.this.id
  rest_api_id   = aws_api_gateway_rest_api.this.id
  stage_name    = "dev"
}

resource "aws_api_gateway_usage_plan" "this" {
  name = "Usage Plan"

  api_stages {
    api_id = aws_api_gateway_rest_api.this.id
    stage  = aws_api_gateway_stage.this.stage_name
  }
}

resource "aws_api_gateway_api_key" "this" {
  name = local.api_key
}

resource "aws_api_gateway_usage_plan_key" "this" {
  key_id        = aws_api_gateway_api_key.this.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.this.id
}


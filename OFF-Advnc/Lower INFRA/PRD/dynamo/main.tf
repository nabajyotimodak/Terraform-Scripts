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
  description = "Env for dynamodb (dev, stg, prod)"
  type = string
  default = "PRD"
}

module "ReadingList" {
  source = "../modules/dynamodb"
  name           = "ReadingList-PRD"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "salesforceId"
  range_key      = "contentId"
  env = var.env
  tags = {
    Name        = "Reading List Table"
    Environment = "PRD"
  }
}

module "InterestsTopics" {
  source = "../modules/dynamodb"
  name           = "InterestsTopics-PRD"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "salesforceId"
  range_key      = "topicId"
  env = var.env
  tags = {
    Name        = "Interests-Topics Table"
    Environment = "PRD"
  }
}

module "InterestsSectors" {
  source = "../modules/dynamodb"
  name           = "InterestsSectors-PRD"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "salesforceId"
  range_key      = "sectorId"
  env = var.env
  tags = {
    Name        = "Interests-Sectors Table"
    Environment = "PRD"
  }
}

module "LikesDislikes" {
  source = "../modules/dynamodb"
  name           = "LikesDislikes-PRD"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "salesforceId"
  range_key      = "contentId"
  env = var.env
  tags = {
    Name        = "Likes Dislikes Table"
    Environment = "PRD"
  }
}

module "MeteredReading" {
  source = "../modules/dynamodb"
  name           = "MeteredReading-PRD"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "emailId"
  env = var.env
  tags = {
    Name        = "Metered Reading Table"
    Environment = "PRD"
  }
}

module "EmailTemplates" {
  source = "../modules/dynamodb"
  name           = "EmailTemplates-PRD"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "templateId"
  env = var.env
  tags = {
    Name        = "Email Templates Table"
    Environment = "PRD"
  }
}


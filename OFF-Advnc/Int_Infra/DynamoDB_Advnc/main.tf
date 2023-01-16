
module "ReadingList" {
  source = "../modules/dynamodb"
  name           = "ReadingList-DEV"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "salesforceId"
  range_key      = "contentId"
  tags = {
    Name        = "Reading List Table"
    Environment = "dev"
  }
}

module "InterestsTopics" {
  source = "../modules/dynamodb"
  name           = "InterestsTopics-DEV"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "salesforceId"
  range_key      = "topicId"
  tags = {
    Name        = "Interests-Topics Table"
    Environment = "dev"
  }
}

module "InterestsSectors" {
  source = "../modules/dynamodb"
  name           = "InterestsSectors-DEV"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "salesforceId"
  range_key      = "sectorId"
  tags = {
    Name        = "Interests-Sectors Table"
    Environment = "dev"
  }
}

module "LikesDislikes" {
  source = "../modules/dynamodb"
  name           = "LikesDislikes-DEV"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "salesforceId"
  range_key      = "contentId"
  tags = {
    Name        = "Likes Dislikes Table"
    Environment = "dev"
  }
}

module "MeteredReading" {
  source = "../modules/dynamodb"
  name           = "MeteredReading-DEV"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "emailId"
  tags = {
    Name        = "Metered Reading Table"
    Environment = "dev"
  }
}

module "EmailTemplates" {
  source = "../modules/dynamodb"
  name           = "EmailTemplates-DEV"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "templateId"
  tags = {
    Name        = "Email Templates Table"
    Environment = "dev"
  }
}

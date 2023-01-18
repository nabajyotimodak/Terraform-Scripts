resource "aws_dynamodb_table" "this" {
  name           = var.name
  read_capacity  = var.read_capacity
  write_capacity = var.write_capacity
  hash_key       = var.hash_key
  range_key      = var.range_key

  attribute {
    name = var.hash_key
    type = "S"
  }

  # attribute {
  #   name = var.range_key
  #   type = "S"
  # }

 dynamic "attribute" {
    for_each = var.range_key != null ? toset([1]) : toset([])
    content {
      name = var.range_key
      type = "S"
    }
  }  



  tags = var.tags
}
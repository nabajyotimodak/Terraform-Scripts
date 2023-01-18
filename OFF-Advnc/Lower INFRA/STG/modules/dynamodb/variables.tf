variable "name" {
    type = string
    description = "Name of DynamoDB table"
    default = ""
}

variable "read_capacity" {
    description = ""
    default = 20
}

variable "write_capacity" {
    description = ""
    default = 20
}

variable "hash_key" {
    type = string
    description = ""
    default = ""
}

variable "range_key" {
    description = ""
    default = null
    type = string
}

variable "tags" {
    type = map
    description = ""
    default = {}
}
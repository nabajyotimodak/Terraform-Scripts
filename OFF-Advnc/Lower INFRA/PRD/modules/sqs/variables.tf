variable "tags" {
    type = map
    description = "Tags to map to each resource"
    default = {}
}

variable "name" {
    type = string
    default = ""
}

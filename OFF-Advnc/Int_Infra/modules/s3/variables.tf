variable "tags" {
    type = map
    description = "Tags to map to each resource"
    default = {}
}

variable "bucket_name" {
    description = "Globally unique bucket name for remote state"
}

variable "kms_master_key_arn" {
    description = "Optional key arn if not using the default"
    default = ""
}

variable "aws_s3_bucket_policy" {
    description = "Optional policy. This will override the default"
    default = ""
}
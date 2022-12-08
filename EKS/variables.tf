# Input Variables
variable "aws_region" {
  description = "Region in which AWS resources to be created"
  type        = string
  default     = "us-east-1"
}

variable "subnet_id_1" {
  description = "Subnet ID of availability Zone us-east-1a"
  type        = string
  default     = "subnet-078cb4ad7da15037c"
}

variable "subnet_id_2" {
  description = "Subnet ID of availability Zone us-east-1b"
  type        = string
  default     = "subnet-0a4f49967e1c3b051"
}

variable "subnet_id_3" {
  description = "Subnet ID of availability Zone us-east-1c"
  type        = string
  default     = "subnet-03ff0bfd57d2a63c9"
}

variable "subnet_id_4" {
  description = "Subnet ID of availability Zone us-east-1d"
  type        = string
  default     = "subnet-0c94de0b7fb895a79"
}

variable "subnet_id_5" {
  description = "Subnet ID of availability Zone us-east-1f"
  type        = string
  default     = "subnet-0e2888216e27c73d4"
}



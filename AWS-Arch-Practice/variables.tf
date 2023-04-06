##############################################################
# List of Locals / Local Variables
# Input Variables for Region us-east-2 (Ohio)
##############################################################


variable "aws_region" {
  description = "AWS-Region"
  type        = string
  default     = "us-east-1"
}

variable "custom_ami" {
  description = "Custom Ami ID of the EC2"
  type        = string
  default     = "ami-047878f9f91488bfc"
  sensitive   = true
}

variable "subnet" {
  description = "Subnet of the EC2"
  type        = string
  default     = "subnet-091f42589855b9489"
}

variable "security_group_ec2" {
  description = "Security group of the EC2"
  type        = string
  default     = "ID of the SG of EC2"
}

variable "availability_zone" {
  description = "Availability zone of the EC2"
  type        = string
  default     = "us-east-1b"
}

variable "iam_role_name" {
  description = "IAM role name attached with the EC2"
  type        = string
  default     = "rasa-dynamodb-access"
}

variable "iam_role_arn" {
  description = "IAM role arn attached with the EC2"
  type        = string
  default     = "arn:aws:ARN of the role to add"
}

variable "vpc_id" {
  description = "VPC ID of the new-vpc created"
  type        = string
  default     = "VPC-ID"
}

variable "security_group_alb" {
  description = "Security group of the ALB"
  type        = string
  default     = "ID of the SG of ALB"
}

variable "subnet_public1a" {
  description = "Subnet 1a for alb (1)"
  type        = string
  default     = "subnet-ID"
}

variable "subnet_public1b" {
  description = "Subnet 1b for alb (2)"
  type        = string
  default     = "subnet-ID"
}
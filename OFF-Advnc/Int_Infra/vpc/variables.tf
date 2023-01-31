variable "region" {
  type    = string
  default = "us-east-1"
}
# variable "access_key" {
#      default = "<PUT IN YOUR AWS ACCESS KEY>"
# }
# variable "secret_key" {
#      default = "<PUT IN YOUR AWS SECRET KEY>"
# }
variable "availabilityZone" {
  default = "us-east-1a"
}
variable "instanceTenancy" {
  default = "default"
}
variable "dnsSupport" {
  default = true
}
variable "dnsHostNames" {
  default = true
}
variable "vpcCIDR" {
  default = "10.0.0.0/16"
}
variable "publicSubnet1CIDR" {
  default = "10.0.1.0/24"
}
variable "publicSubnet2CIDR" {
  default = "10.0.2.0/24"
}
variable "privateSubnet1CIDR" {
  default = "10.0.3.0/24"
}
variable "privateSubnet2CIDR" {
  default = "10.0.4.0/24"
}
variable "destinationCIDRblock" {
  default = "0.0.0.0/0"
}
variable "ingressCIDRblock" {
  type    = list(any)
  default = ["0.0.0.0/0"]
}
variable "egressCIDRblock" {
  type    = list(any)
  default = ["0.0.0.0/0"]
}
variable "mapPublicIP" {
  default = true
}

variable "securityGroupRules" {
  default = [
    {
      from_port = 0
      to_port = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "ingressNetworkAclRules" {
  default = [
    {
      rule_no    = 100
      from_port  = 0
      to_port    = 0
      protocol   = "-1"
      cidr_block = ["0.0.0.0/0"]
      action     = "allow"
    }
  ]
}

variable "egressNetworkAclRules" {
  default = [
    {
      rule_no    = 100
      from_port  = 0
      to_port    = 0
      protocol   = "-1"
      cidr_block = ["0.0.0.0/0"]
      action     = "allow"
    }
  ]
}
# end of variables.tf
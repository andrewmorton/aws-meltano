# Provided config

variable "prefix" {
  type = string
  description = "Prefix for the environment to allow for multi-region deployments"
  default = "qualytics"
}

# VPC Vars
variable "vpc_cidr_base" {
  type = string
  description = "CIDR to base the eks VPC off of"
  default =  "10.0.0.0/16"
}

variable "target_vpc_azs" {
  type = list
  description = "List of AZs to use for VPC creation"
  default = [
    "us-east-1b",
    "us-east-1c"
  ]
}
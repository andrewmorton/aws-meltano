locals {
  cidr_subnets = cidrsubnets(var.vpc_cidr_base, 2, 2, 2, 2)
}

module "meltano_vpc" {
  source  = "terraform-aws-modules/vpc/aws"

  name = "${var.prefix}-vpc"
  cidr = var.vpc_cidr_base
  azs = var.target_vpc_azs

  private_subnets = [
    local.cidr_subnets[0],
    local.cidr_subnets[1],
  ]

  public_subnets = [
    local.cidr_subnets[2],
    local.cidr_subnets[3],
  ]

  enable_nat_gateway = true
  enable_vpn_gateway = false

  tags = {
    Name = "${var.prefix}-vpc"
    Terraform = "True"
  }
}


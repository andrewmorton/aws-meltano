data aws_subnet "vpc_public_subnet" {
  id = var.deployment_vpc_public_subnet_id
}

data aws_vpc "deployment_vpc" {
  id = var.deployment_vpc_id
}

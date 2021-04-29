source_provider_assume_role_arn = "arn:aws:iam::231086498412:role/candyland-service-role"

# RDS Options
meltano_user = "meltano"
meltano_created_db = "meltano"

# VPC Options
deployment_vpc_id = "vpc-0d7bfcf7b6641d821"
deployment_vpc_private_subnets = [
  "subnet-0da0a7de44ab9251d"
]
deployment_vpc_public_subnet_id = "subnet-0348810669c5aff08"

# EC2 Options
eks_admin_trusted_cidr = [
  "45.46.240.94/32",
]

sysadmin_keypair_name = "mavencollective-master-keypair"

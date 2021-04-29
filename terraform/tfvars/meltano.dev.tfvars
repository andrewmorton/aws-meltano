source_provider_assume_role_arn = "arn:aws:iam::231086498412:role/candyland-service-role"

# RDS Options
meltano_user = "meltano"
meltano_created_db = "meltano"

# VPC Options
target_vpc_azs = [
  "us-east-az1",
  "us-east-az2"
]

# EC2 Options
eks_admin_trusted_cidr = [
  "45.46.240.94/32",
]

sysadmin_keypair_name = "mavencollective-master-keypair"

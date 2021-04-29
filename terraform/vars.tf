# Global config

variable "prefix" {
  type = string
  description = "Prefix for the environment to allow for multi-region deployments"
  default = "qualytics-dev"
}

variable "source_provider_assume_role_arn" {
  type = string
  description = "Assume role arn for the source account user"
}

# RDS Vars
variable "meltano_user" {
  type = string
  description = "User for meltano access to the RDS"
  default = "meltano"
}

variable "meltano_created_db" {
  type = string
  description = "Assume role arn for the source account user"
  default = "meltano"
}

variable "rds_instance_size" {
  type = string
  description = "DB instance size to use for the meltano rds"
  default = "db.t3.micro"
}

variable "rds_multi_az" {
  type = bool
  description = "Whether the RDS should be multi az. True or False."
  default = false
}



# VPC Vars

variable "vpc_cidr_base" {
  type = string
  description = "CIDR to base the VPC off of"
  default =  "10.0.0.0/24"
}

variable "target_vpc_azs" {
  type = list
  description = "List of AZs to use for VPC creation"
}


# EC2 Vars

variable "eks_asg_instance_size" {
  type = string
  description = "Size of EC2 machines that are deployed in the cluster"
  default = "t3.small"
}

variable "eks_ec2_cluster_fleet" {
  type = number
  description = "Number of EC2 within the EKS fleet"
  default = 2
}

variable "eks_admin_trusted_cidr" {
  type = list
  description = "List of trusted CIDR ranges to access eks sysadmin"
}

variable "sysadmin_keypair_name" {
  type = string
  description = "Name of the keypair to use for SSH connection to sysadmin"
}

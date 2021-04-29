variable "source_provider_assume_role_arn" {
  type = string
  description = "Assume role arn for the source account user"
}

# RDS Vars
variable "meltano_user" {
  type = string
  description = "User for meltano access to the RDS"
}

variable "meltano_created_db" {
  type = string
  description = "Assume role arn for the source account user"
}

# VPC Vars

variable "deployment_vpc_id" {
  type = string
  description = "VPC ID to deploy the EKS cluster within"
}

variable "deployment_vpc_private_subnets" {
  type = list
  description = "Deployment VPC Private Subnet IDs"
}

# EC2 Vars

variable "eks_asg_instance_size" {
  type = string
  description = "Size of EC2 machines that are deployed in the cluster"
}

variable "eks_ec2_cluster_fleet" {
  type = number
  description = "Number of EC2 within the EKS fleet"
}

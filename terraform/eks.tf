data "aws_eks_cluster" "cluster" {
  name = module.eks_cluster.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks_cluster.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
  version                = "~> 1.9"
}

module "eks_cluster" {
  source  = "terraform-aws-modules/eks/aws"
  version = "15.1.0"
  cluster_name = "meltano_cluster"
  cluster_version = "1.17"
  subnets = var.deployment_vpc_private_subnets
  vpc_id = var.deployment_vpc_id

  worker_groups = [
    {
      instance_type = var.eks_asg_instance_size
      asg_max_size = var.eks_ec2_cluster_size
    }
  ]
}

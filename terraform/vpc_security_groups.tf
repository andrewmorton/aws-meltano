resource aws_security_group "sysadmin_security_group" {
  name = "${var.prefix}-sysadmin-sg"
  description = "Access to the EKS sysadmin machine"
  vpc_id = data.aws_vpc.deployment_vpc.id

  ingress {
    description = "SSH from trusted sources"
    from_port = 22
    to_port = 22
    protocol = "TCP"
    cidr_blocks = var.eks_admin_trusted_cidr
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}

resource aws_security_group "meltano_rds_sg" {
  name = "${var.prefix}-meltano-rds-sg"
  vpc_id = data.aws_vpc.deployment_vpc.id
  
  ingress {
    description = "Postgresql traffic from eks cluster group and sysadmin"
    from_port = 5432
    to_port = 5432
    protocol = "TCP"
    security_groups = [
      module.eks_cluster.cluster_primary_security_group_id,
      aws_security_group.sysadmin_security_group.id
    ]
  }
  
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}

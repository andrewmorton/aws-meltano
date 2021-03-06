data aws_ami "amazon_linux" {
  most_recent = true

  filter {
    name = "name"
    values = [
      "amzn2-ami-hvm-2.0*-x86_64-gp2"
    ]
  }

  owners = [
    "137112412989"
  ]
}

resource aws_iam_role "meltano_ec2_sysadmin_role" {
  name = "meltano_ec2_sysadmin_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

}

resource aws_iam_role_policy_attachment "attach_sysadmin_access" {
  # TODO: Create a custom role for EC2 management of EKS without admin access
  role = aws_iam_role.meltano_ec2_sysadmin_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource aws_iam_instance_profile "sysadmin_ec2_profile" {
  name = "eks_sysadmin_profile"
  role = aws_iam_role.meltano_ec2_sysadmin_role.name
}


resource aws_instance "eks_sysadmin" {
  ami = data.aws_ami.amazon_linux.id
  instance_type = "t3.medium"
  associate_public_ip_address = true
  subnet_id = module.meltano_vpc.public_subnets[0]
  key_name = var.sysadmin_keypair_name
  iam_instance_profile = aws_iam_instance_profile.sysadmin_ec2_profile.name
  security_groups = [
    aws_security_group.sysadmin_security_group.id
  ]

  tags = {
    Name = "${var.prefix}-sysadmin"
    Terraform = true
  }

  user_data = <<EOF
  #!/bin/bash
  
  mkdir /home/ec2-user/bin
  sudo yum install -y amazon-linux-extras
  sudo yum update
  sudo yum install -y jq postgresql 
  curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C .
  mv eksctl /home/ec2-user/bin

  curl -LO https://dl.k8s.io/release/v1.17.0/bin/linux/amd64/kubectl
  chmod 777 kubectl
  mv kubectl /home/ec2-user/bin/
  chown ec2-user -R /home/ec2-user/bin
  chmod 700  /home/ec2-user/bin -R

  runuser -l ec2-user -c 'aws eks update-kubeconfig --region ${var.region} --name ${var.eks_cluster_name}'
  # TODO: add a runuser line here to pull the sql for postgres and the meltano config yaml from parameter store

  EOF
}

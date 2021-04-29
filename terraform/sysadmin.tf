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

resource aws_instance "eks_sysadmin" {
  ami = data.aws_ami.amazon_linux.id
  instance_type = "t3.medium"
  associate_public_ip_address = true
  subnet_id = module.meltano_vpc.public_subnets[0]
  key_name = var.sysadmin_keypair_name
  security_groups = [
    aws_security_group.sysadmin_security_group.id
  ]

  tags = {
    Name = "${var.prefix}-sysadmin"
    Terraform = true
  }

  user_data = <<EOF
  #!/bin/bash

  sudo yum install -y amazon-linux-extras
  sudo yum update
  sudo yum install -y jq postgresql 
  curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
  sudo mv /tmp/eksctl /usr/local/bin

  EOF
}

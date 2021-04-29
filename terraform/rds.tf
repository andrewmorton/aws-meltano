resource random_password "meltano_rds_master_pass" {
  length = 62
  special = true
}

resource random_password "meltano_user_pass" {
  length = 20
  special = true
}

resource aws_db_subnet_group "rds_private_subnet_group" {
  name = "${var.prefix}-db-subnet-group"

  subnet_ids = var.deployment_vpc_private_subnets

  tags = {
    Name = "${var.prefix}-db-subnet-group"
    Terraform = true
  }
}


resource aws_db_instance "meltano_rds" {
  name = "${var.prefix}-meltano-rds"
  allocated_storage = 100
  engine = "postgres"
  engine_version = "13.1"
  instance_class = var.rds_instance_size
  username = "master"
  password = random_password.meltano_rds_master_pass.result
  db_subnet_group_name = aws_db_subnet_group.rds_private_subnet_group.name
  multi_az = var.rds_multi_az
  vpc_security_group_ids = [
    aws_security_group.meltano_rds_sg.id
  ]
  
  tags = {
    Name = "${var.prefix}-meltano-rds"
    Terraform = "true"
  }
}

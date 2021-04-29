locals {
  param_suffix_map = { # Add more metadata about infrastructure here
    "rds/endpoint" = aws_db_instance.meltano_rds.address,
    "rds/master_user" = aws_db_instance.meltano_rds.username,
    "rds/master_password" = random_password.meltano_rds_master_pass.result,
    "rds/meltano_password" = random_password.meltano_user_pass.result,
  }

  system_parameters_map = { # Creating Object to consume in for_each
    for path, value in local.param_suffix_map:
    "/${var.prefix}/${path}" => value
  }

}

resource aws_ssm_parameter "dynamic_env_parameters" {
  for_each = {
    for path, value in local.system_parameters_map:
    path => value
  }
    
  type = "String"
  name = each.key
  value = each.value
}

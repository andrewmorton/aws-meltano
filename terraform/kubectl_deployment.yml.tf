resource local_file "kubectl_deployment_yaml" {
  filename = "meltano_deployment.yml"
  content = templatefile("${path.module}/tf-templates/kubernetes_config_yaml.tmpl", {
    db_username = var.meltano_user,
    db_password = random_password.meltano_user_pass.result,
    db_endpoint = aws_db_instance.meltano_rds.address,
    created_db_name = var.meltano_created_db
    }
  )
}

provider "aws" {
  region = var.region
  assume_role {
    role_arn = var.source_provider_assume_role_arn
  }
}

terraform {
  backend "s3" {
    bucket = "mavencollective-net-tf"
    region = "us-east-1"
    key = "mavencollective-eks-meltano"
  }
}

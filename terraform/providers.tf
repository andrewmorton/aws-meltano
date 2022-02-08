provider "aws" {
 # Fill this in to interact with the target AWS account.
 # Prefer using an assumed role to passing credentials directly
}

provider "kubernetes" {
  # Fill this in to interact with the kubernetes cluster that has been provisioned
}

# Suggest using s3 backend for saving terraform state below
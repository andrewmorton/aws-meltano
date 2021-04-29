# To Use:

1. Clone the repo to a sysadmin machine that can assume an IAM role or local machine using a AWS IAM service user
2. Install terraform if not already present
3. Within the providers.tf file, update the backend configuration to an appropriate s3 bucket for terraform state
- Change argument `bucket` to an s3 bucket the container has access to
- Change argument `region` to the region the s3 bucket lives in
- Change argument `key` to an s3 object key that the terraform.tfstate file will be saved to (Use this to separate out different environments)
- This can be automated at a later date
4. from a command line, change directory into terraform directory within the repo
5. If this is a different environment than the dev environment, create a new tfvars file for the project by using an existing tfvars as a template
- These are within repo root at `terraform/tfvars`
6. Run terraform init to download and install all modules
- This will also check if your instance or IAM user has the appropriate permissions in AWS to assume the target role for terraform to use when building infrastructure.
7. Run `terraform plan -var-file tfvars/<my var file>.tfvars` in order to plan infrastructure changes with terraform
8. Run `terraform apply -var-file tfvars/<my var file>.tfvars` and enter 'yes' when prompted to apply infrastructure changes
9. Once changes are applied, ssh to the public IP of the Sysadmin machine. This has the access needed to interact with EKS and the RDS that have been provisioned
10. Eksctl should already be installed, but you may need to update your config. 
11. Move deployment yaml from your repo into the sysadmin machine and `kubectl apply -f <my_deployment_yaml>.yml`.
- This should have been created by Terraform during apply
- If terraform was run from a sysadmin machine already with access to EKS, you can apply the deployment yaml without moving it to the instance first
12. Kubernetes should now be hosting an unconfigured instance of meltano, which can be configured by accessing the container directly

# Thought process:
- I can use terraform to create a configuration Yaml
- Investigating/brushing up on kubernetes config yaml, I came across a suggestion to use tools other than templating to create kubernetes yamls
- This seemed to be more a suggestion to use yq (jq for Yamls, who knew?) rather than to not template things
- There's a great template here for a simple pod, that will become my tf-template file


# Issues
- Meltano seems pretty cool, but they really don't have an easily accessible quick start guide. I had to sort through a bit of information to find what I needed
- I use this repo to manage my terraform service users in my own account: github.com:andrewmorton/terraform-service-users.git and I needed to update minimum permissions a few times
- ran into permissions Issues with S3 bucket for remote state. We use artifactory for this very reason.
- Ran Terraform with TF_LOG turned to DEBUG
- ListObjects failed. I believe this is because the service user I have set in AWS_PROFILE does not have s3 bucket permissions (the service users are only really allowed to assume role by default in case of credential compromise)
- Added S3 full access to service users group permissions, this fixed the issue
- In order to actually deploy an EKS cluster, I also need to have a VPC and subnets for it to live in. If The assumption is that this repo is going to be used in an empty account, I would need to create even more resources. To save time, I used my existing VPC as a data source instead
- Tried to apply to my VPC, but my VPC doesn't go across multiple availability zones. Adding VPC module
- aws_db_instance resource changed to have argument "identifier" instead of name for the RDS name, so had to destroy and rebuild RDS for nice name
- After getting the cluster provisioned, I can't access it. IAM permissions I believe have to be passed to aws-auth map, which would be a module setting

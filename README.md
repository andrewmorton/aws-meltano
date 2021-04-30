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
10. Sign in to AWS Console and add the IAM identity provider for the eks cluster OIDC [eks guide aws](https://docs.aws.amazon.com/eks/latest/userguide/getting-started-console.html)
11. eksctl and kubectl should already be installed, but you may need to update your config. 
12. Move deployment yaml from your repo into the sysadmin machine and `kubectl apply -f <my_deployment_yaml>.yml`.
- This should have been created by Terraform during apply
- If terraform was run from a sysadmin machine already with access to EKS, you can apply the deployment yaml without moving it to the instance first
- you can use SCP for this if you have the ssh keypair to access the sysadmin EC2 `scp -i ~/.ssh/<my-private-key> ec2-user@<public-ip-of-sysadmin>`
13. Kubernetes should now be hosting an unconfigured instance of meltano, which can be configured by accessing the container directly

# Issues
- Meltano seems pretty cool, but they really don't have an easily accessible quick start guide. I had to sort through a bit of information to find what I needed
- I use this repo to manage my terraform service users in my own account: github.com:andrewmorton/terraform-service-users.git and I needed to update minimum permissions a few times
- ran into permissions Issues with S3 bucket for remote state
- Ran Terraform with TF_LOG turned to DEBUG
- ListObjects failed. I believe this is because the service user I have set in AWS_PROFILE does not have s3 bucket permissions (the service users are only really allowed to assume role by default in case of credential compromise)
- Added S3 full access to service users group permissions, this fixed the issue
- In order to actually deploy an EKS cluster, I also need to have a VPC and subnets for it to live in. If The assumption is that this repo is going to be used in an empty account, I would need to create even more resources. To save time, I used my existing VPC as a data source instead
- Tried to apply to my VPC, but my VPC doesn't go across multiple availability zones. Adding VPC module
- aws_db_instance resource changed to have argument "identifier" instead of name for the RDS name, so had to destroy and rebuild RDS for a nice name
- After getting the cluster provisioned, I can't access it. IAM permissions I believe have to be passed to aws-auth map, which would be a module setting
- EC2 user data wasn't working correctly, sysadmin was not successfully setup.
- Updated EC2 user data to run as ec2-user, but permissions are being a bit of an issue, may switch to running as root to save time
- kubectl issue wasn't a permissions issue, the download wasn't working as expected, AWS link was out of date
- I'm also running into another IAM issue with EKS, the cluster creator is the only IAM role that can login currently
- Investigated the module, I can add an argument to map roles to the cluster
- Based on default argument in Git repo, I can add the sysadmin user as a system master as well
- Turns out that worked!
- Turns out I have some syntax errors in kubernetes deployment yaml
- Found a simple template that I can use, this can be updated later and for now I can merge with my existing yaml
- based on kubectl output, found needed to explicitly make the values strings and remove the comment
- meltano will now apply, but will not stay running, this is likely because of the configuration needed, the default docker container isn't good enough.
- Meltano says on their website the product should basically work without too much trouble, so trying to send command `meltano init` to container
- Meltano init is working, but now it's unable to communicate with the RDS
- Investigated a few articles, nothing that fit, so went back to AWS console to double check security groups
- Found that the worker groups might be using a different security group, Testing this by manually adding security group to RDS security group rule
- That got it, need to update the module so the correct EKS security group is going to the RDS security group.
- Module output needed is worker_security_group_id
- Logs for Meltano seems to indicate everything is finishing up, but the service isn't staying running, which means the container stops and is never waiting ready
- Re-read meltano docs, I might need to source a file to keep the service running `cd to demo-project, then source ../.venv/bin/activate`
- Found that `source` isn't available in the meltano image, but `meltano` should just start the UI on port 5000
- `meltano` by itself didn't start the ui, but `meltano ui` did, and now the pod is staying running

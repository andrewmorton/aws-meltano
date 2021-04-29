# To Use:

1. Clone the repo to a sysadmin machine or container with terraform installed
2. Update the backend configuration to an appropriate s3 bucket
- Change argument `bucket` to an s3 bucket the container has access to
- Change argument `region` to the region the s3 bucket lives in
- Change argument `key` to an s3 object key that the terraform.tfstate file will be saved to (Use this to separate out different environments)
3. 

# Thought process:
- I can use terraform to create a configuration Yaml
- Investigating/brushing up on kubernetes config yaml, I came across a suggestion to use tools other than templating to create kubernetes yamls
- This seemed to be more a suggestion to use yq (jq for Yamls, who knew?) rather than to not template things
- There's a great template here for a simple pod, that will become my tf-template file


# Issues
- Meltano seems pretty cool, but they really don't have an easily accessible quick start guide. I had to sort through a bit of information to find what I needed
- I use this repo to manage my terraform service users in my own account: github.com:andrewmorton/terraform-service-users.git and I needed to update minimum permissions a few times
- ran into permissions Issues with S3 bucket for remote state. We use artifactory for this very reason.
- In order to actually deploy an EKS cluster, I also need to have a VPC and subnets for it to live in. If The assumption is that this repo is going to be used in an empty account, I would need to create even more resources. To save time, I used my existing VPC as a data source instead
-

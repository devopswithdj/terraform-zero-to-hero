# Backend Tf file stores the remote state configuration for Terraform
terraform {
  backend "s3" {
    bucket       = "tfstatefile-learning"   # Replace with your S3 bucket name
    key          = "day4/terraform.tfstate" # Replace with your desired state file path
    region       = "us-west-2"              # Replace with your AWS region
    use_lockfile = true
  }
}
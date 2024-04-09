# Terraform state will be stored on Shared-Services
terraform {
  backend "s3" {
    bucket         = "workspaces-terraform-state" # Shared Services
    region         = "us-west-2"
    profile        = "shared"
    # Set this only when using Terraform Workspaces
    key            = "infra/terraform.tfstate"
    dynamodb_table = "workspaces-state-lock"

    # When NOT Implementing Workspaces Do the following:
    # terraform init \
    #   -backend-config="dynamodb_table=shared-services-us-east-1-lock-table" \
    #   -backend-config="key=terraform-demo-my-bucket/terraform.tfstate"
    # terraform plan -var 'env=dev'
    # terraform apply -var 'env=dev'
  }
}

provider "aws" {
  region = var.region
  profile = "shared"
  assume_role {
    role_arn = "arn:aws:iam::${lookup(var.account_mapping, terraform.workspace)}:role/terraform-role"
  }
}


resource "aws_s3_bucket" "my_bucket" {
  bucket = "terraform-multiaccount-bucket-${terraform.workspace}"

  tags = {
    Name        = "terraform-assume-role-${terraform.workspaces}"
    Environment = "${var.env}"
  }
}
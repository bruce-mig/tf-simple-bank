terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.34.0"
    }
  }
  cloud {
    organization = "bruce-mig"
    workspaces {
      name = "tf-simple-bank-dev"
    }
  }
  # backend "s3" {
  #   bucket = "terraform-backend-31012024"
  #   key = "simplebank_dev_backend.tfstate"
  #   region = var.region
  #   encrypt = true
  #   dynamodb_table = "terraform-lock-table"
  # }
}

provider "aws" {
  region = "af-south-1"
}

# provider "vault" {
#   address = "<>:8200"
#   skip_child_token = true

#   auth_login {
#     path = "auth/approle/login"

#     parameters = {
#       role_id = "<>"
#       secret_id = "<>"
#     }
#   }
# }

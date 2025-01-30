terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.84.0"
    }
  }

  cloud {
    organization = "bruce-mig"
    workspaces {
      name = "tf-simple-bank-prod"
    }
  }

  # backend "s3" {
  #   bucket = "simple-bank-tf-state"
  #   key = "tf-simplebank/prod-terraform.tfstate"
  #   region = var.region
  #   encrypt = true
  #   dynamodb_table = "terraform-state-locking"
  # }
}

provider "aws" {
  region = "af-south-1"
}

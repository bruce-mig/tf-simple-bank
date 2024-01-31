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
      name = "tf-simple-bank-qa"
    }
  }
  #   backend "s3" {
  #     bucket = "terraform-backend-31012024"
  #     key = "simplebank_qa_backend.tfstate"
  #     region = var.region
  #     encrypt = true
  #     dynamodb_table = "terraform-lock-table"
  #   }
}

provider "aws" {
  region = "af-south-1"
}
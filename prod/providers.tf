terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.33.0"
    }
  }
  #   backend "s3" {
  #   bucket = "simplebank-backend-29012024"
  #   key = "tfstate/terraform.tfstate"
  #   region = var.region
  #   encrypt = true
  #   dynamodb_table = "terraform-lock-table"
  # }
}

provider "aws" {
  region = "af-south-1"
}

# terraform {
#   required_version = ">=0.12"
#   backend "s3" {
#     bucket = "simplebank-backend-29012024"
#     key = "tfstate/terraform.tfstate"
#     region = var.region
#     encrypt = true
#     dynamodb_table = "terraform-lock-table"
#   }
# }

provider "aws" {
  region  = "af-south-1"
}
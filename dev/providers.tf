# terraform {
#   required_version = ">=0.12"
#   backend "s3" {
#     bucket = "terraform-backend-31012024"
#     key = "simplebank_backend.tfstate"
#     region = var.region
#     encrypt = true
#     dynamodb_table = "terraform-lock-table"
#   }
# }

provider "aws" {
  region = "af-south-1"
}
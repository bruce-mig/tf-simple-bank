module "dev" {
  source = "../modules/simplebank"

  public_key_location  = var.public_key_location
  private_key_location = var.private_key_location
  ec2_user             = var.ec2_user
  db_password          = var.db_password
  db_username          = var.db_username
}

# data "vault_kv_secret_v2" "example" {
#   mount = "secret" // change it according to your mount
#   name  = "test-secret" // change it according to your secret
# }
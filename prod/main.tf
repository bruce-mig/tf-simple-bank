module "prod" {
  source = "../modules/simplebank"

  public_key_location  = var.public_key_location
  private_key_location = var.private_key_location
  ec2_user             = var.ec2_user
  db_password          = var.db_password
  asg_min_size         = 0
  asg_max_size         = 0
}
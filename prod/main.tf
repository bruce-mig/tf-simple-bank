module "prod" {
  source = "../modules/simplebank"

  public_key_location  = "/home/migeri/.ssh/test_rsa.pub"
  private_key_location = "/home/migeri/.ssh/test_rsa"
  ec2_user             = "ec2-user"
  asg_min_size         = 0
  asg_max_size         = 0
}
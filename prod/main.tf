module "prod" {
  source = "../modules/simplebank"

  environment = {
    name           = "prod"
    network_prefix = "10.2"
  }

  asg_min_size = 0
  asg_max_size = 0
}
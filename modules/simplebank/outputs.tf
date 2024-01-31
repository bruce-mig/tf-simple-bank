output "environment_url" {
  value = module.simplebank_alb.dns_name
}

output "ec2_public_ip" {
  value = module.ec2_instance.public_ip
}
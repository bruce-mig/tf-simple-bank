output "environment_url" {
  value = module.simplebank_alb.dns_name
}

output "ec2_public_ip" {
  value = aws_instance.simplebank-app.public_ip
}
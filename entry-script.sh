#!/bin/bash
sudo yum update -y && sudo yum install -y docker
sudo systemctl start docker
sudo usermod -aG docker ${var.ec2_user}
docker run -p 8080:80 bmigeri/simplebank:latest

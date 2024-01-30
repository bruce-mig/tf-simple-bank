variable "instance_type" {
  description = "Type of EC2 instance to provision"
  default     = "t3.nano"
}

variable "ami_filter" {
  description = "Name filter and owner for AMI"

  type = object({
    name  = string
    owner = string
  })

  default = {
    name  = "amzn2-ami-hvm-*-x86_64-gp2"
    owner = ""
  }
}

variable "network_prefix" {
  description = "Network Prefix for the Environment"

  type = map(string)
  default = {
    "dev"  = "10.0"
    "qa"   = "10.1"
    "prod" = "10.2"
  }
}

variable "asg_min_size" {
  description = "Minimum number of instances in the ASG"
  default     = 0
}

variable "asg_max_size" {
  description = "Maximum number of instances in the ASG"
  default     = 0
}

variable "public_key_location" {
  default = "/home/migeri/.ssh/id_rsa.pub"
}

variable "ec2_user" {
  description = "the name of the IAM user with access to resources"
  default     = "ec2-user"
}

variable "private_key_location" {
  default = "/home/migeri/.ssh/id_rsa"
}

variable "region" {
  type    = string
  default = "af-south-1"
}

variable "azs" {
  description = "availability zones"
  type        = list(string)
  default     = ["af-south-1a", "af-south-1b", "af-south-1c"]
}
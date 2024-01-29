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
		name   = "amzn2-ami-hvm-*-x86_64-gp2"
		owner  = "" 
	}
}

variable "environment" {
	description = "Development Environment"	

	type = object({
		name           = string
		network_prefix = string
	})

	default = {
		name           = "dev"
		network_prefix = "10.0"
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
  	default = "ec2-user"
}

variable "private_key_location" {
  default = "/home/migeri/.ssh/id_rsa"
}
variable "db_password" {
  description = "password for postges db"
  type = string
  sensitive = true
}

variable "public_key_location" {
  description = "File location of the ssh public key"
  type        = string
}

variable "ec2_user" {
  description = "the name of the IAM user with access to resources"
  type        = string
}

variable "private_key_location" {
  description = "File location of the ssh private key"
  type        = string
}
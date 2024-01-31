data "aws_ami" "app_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.ami_filter.name]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = [var.ami_filter.owner]
}

module "simplebank_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = terraform.workspace
  cidr = "${lookup(var.network_prefix, terraform.workspace, "10.1")}.0.0/16"

  azs = var.azs
  public_subnets = [
    "${lookup(var.network_prefix, terraform.workspace, "10.1")}.101.0/24",
    "${lookup(var.network_prefix, terraform.workspace, "10.1")}.102.0/24",
    "${lookup(var.network_prefix, terraform.workspace, "10.1")}.103.0/24"
  ]

  enable_nat_gateway = true


  tags = {
    Terraform   = "true"
    Environment = terraform.workspace
  }
}

# module "autoscaling" {
#   source  = "terraform-aws-modules/autoscaling/aws"

#   name     =  "${var.environment.name}-simplebank"
#   min_size = var.asg_min_size
#   max_size = var.asg_max_size

#   vpc_zone_identifier = module.simplebank_vpc.public_subnets
#   target_group_arns   = module.simplebank_alb.target_groups.arn
#   security_groups     = [ module.simplebank_sg.security_group_id ]

#   key_name = aws_key_pair.ssh-key.key_name

#   image_id      = data.aws_ami.app_ami.id
#   instance_type = var.instance_type

#   user_data = file("entry-script.sh")

#   tags = {
#     Name = "${var.environment.name}-server"
#   }
# }

resource "aws_instance" "simplebank-app" {
  ami           = data.aws_ami.app_ami.id
  instance_type = var.instance_type

  subnet_id              = module.simplebank_vpc.public_subnets[0]
  vpc_security_group_ids = [module.simplebank_sg.security_group_id]
  availability_zone      = module.simplebank_vpc.azs[0]

  associate_public_ip_address = true
  key_name                    = aws_key_pair.test_ssh-key.key_name

  user_data = file("../entry-script.sh")

  # connection {
  #   type = "ssh"
  #   host = self.public_ip
  #   user = var.ec2_user
  #   private_key = file(var.private_key_location)
  # }

  # provisioner "file" {
  #   source = "entry-script.sh"
  #   destination = "/home/${var.ec2_user}/entry-script.sh"
  # }

  # provisioner "remote-exec" {
  #   script = file("entry-script.sh")
  #   on_failure = fail
  # }

  # provisioner "local-exec" {
  #   command = "echo ${self.public_ip} > output.txt"
  # }

  tags = {
    Name = "${terraform.workspace}-server"
  }

  depends_on = [ module.simplebank_postgres_db ]
}


module "simplebank_alb" {
  source = "terraform-aws-modules/alb/aws"

  name    = "${terraform.workspace}-simplebank-alb"
  vpc_id  = module.simplebank_vpc.vpc_id
  subnets = module.simplebank_vpc.public_subnets

  # Security Group
  security_groups = [module.simplebank_sg.security_group_id]

  listeners = {
    ex-http-https-redirect = {
      port     = 80
      protocol = "HTTP"
    }
    ex-https = {
      port            = 443
      protocol        = "HTTPS"
      certificate_arn = "arn:aws:iam::123456789012:server-certificate/test_cert-123456789012"

      forward = {
        target_group_key = "ex-instance"
      }
    }
  }

  target_groups = {
    ex-instance = {
      name_prefix = "h1"
      protocol    = "HTTP"
      port        = 80
      target_type = "instance"
    }
  }

  tags = {
    Environment = terraform.workspace
    Project     = "Example"
  }
}

module "simplebank_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  name                = "${terraform.workspace}-simplebank"
  vpc_id              = module.simplebank_vpc.vpc_id
  ingress_rules       = ["http-80-tcp", "https-443-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules        = ["all-all"]
  egress_cidr_blocks  = ["0.0.0.0/0"]
}

resource "aws_key_pair" "test_ssh-key" {
  key_name   = "server-ssh-key"
  public_key = file(var.public_key_location)
}

module "simplebank_postgres_db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = "simple-bank-postgres"

  engine               = "postgres"
  engine_version       = "16"
  family               = "postgres16" # DB parameter group
  major_engine_version = "16"         # DB option group
  instance_class       = "db.t4g.micro"

  allocated_storage     = 1
  max_allocated_storage = 5

  db_name  = "simple-bank"
  username = "root"
  password = var.db_password
  port     = 5432

  multi_az               = true
  db_subnet_group_name   = module.simplebank_vpc.name
  vpc_security_group_ids = [module.simplebank_sg.id]

  backup_retention_period = 1
  skip_final_snapshot     = true
  deletion_protection     = false

}


# resource "aws_instance" "vault" {
#   ami           = data.aws_ami.app_ami.id
#   instance_type = var.instance_type

#   subnet_id              = module.simplebank_vpc.public_subnets[0]
#   vpc_security_group_ids = [module.simplebank_sg.security_group_id]
#   availability_zone      = module.simplebank_vpc.azs[0]

#   associate_public_ip_address = true
#   key_name                    = aws_key_pair.test_ssh-key.key_name

#   user_data = file("../vault-script.sh")

#  tags = {
#     Name = "test"
#     Secret = data.vault_kv_secret_v2.example.data["foo"]
#   }
# }
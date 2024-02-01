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
  cidr = "${lookup(var.network_prefix, terraform.workspace, "10.0")}.0.0/16"

  azs = var.azs
  public_subnets = [
    "${lookup(var.network_prefix, terraform.workspace, "10.0")}.101.0/24",
    "${lookup(var.network_prefix, terraform.workspace, "10.0")}.102.0/24",
    "${lookup(var.network_prefix, terraform.workspace, "10.0")}.103.0/24"
  ]
  create_igw = true

  tags = {
    Terraform   = "true"
    Environment = terraform.workspace
  }
}

module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = terraform.workspace

  ami                    = data.aws_ami.app_ami.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.test_ssh-key.key_name
  vpc_security_group_ids = [module.simplebank_sg.security_group_id]
  subnet_id              = module.simplebank_vpc.public_subnets[0]
  availability_zone      = module.simplebank_vpc.azs[0]

  user_data = file("../entry-script.sh")
  tags = {
    Terraform   = "true"
    Environment = terraform.workspace
  }

  depends_on = [module.simplebank_postgres_db]
}

module "simplebank_alb" {
  source = "terraform-aws-modules/alb/aws"

  name    = "${terraform.workspace}-simplebank-alb"
  vpc_id  = module.simplebank_vpc.vpc_id
  subnets = module.simplebank_vpc.public_subnets

  # Security Group
  security_groups = [module.simplebank_sg.security_group_id]

  target_groups = {
    ex-instance = {
      name_prefix = "h1"
      protocol    = "HTTP"
      port        = 80
      target_type = "instance"
    }
  }

  tags = {
    Terraform   = "true"
    Environment = terraform.workspace
  }
}

module "simplebank_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name                = "${terraform.workspace}-simplebank"
  vpc_id              = module.simplebank_vpc.vpc_id
  ingress_rules       = var.sg_ingress_rules
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
  family               = "postgres16"
  major_engine_version = "16"
  instance_class       = "db.t4g.micro"

  allocated_storage     = 1
  max_allocated_storage = 5

  db_name  = var.db_name
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
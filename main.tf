resource "random_pet" "random" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"  

  name                 = "${random_pet.random.id}-demo-delete"
  cidr                 = "192.168.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  public_subnets       = ["192.168.1.0/24","192.168.2.0/24","192.168.3.0/24"]
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_db_subnet_group" "demo-delete" {
  name       = "${random_pet.random.id}-demo-delete"
  subnet_ids = module.vpc.public_subnets

  tags = {
    Name = "${random_pet.random.id} demo-delete"
  }
}

resource "aws_security_group" "rds" {
  name   = "${random_pet.random.id}-demo-delete_rds"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["192.80.0.0/16"]
  }

  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${random_pet.random.id}-demo-delete_rds"
  }
}

resource "aws_db_parameter_group" "demo-delete" {
  name   = "${random_pet.random.id}-demo-delete"
  family = "postgres15"

  parameter {
    name  = "log_connections"
    value = "1"
  }
}

resource "aws_db_instance" "demo-delete" {
  identifier             = "${var.db_name}-demo-delete-5733689486498"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "15.6"
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.demo-delete.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  parameter_group_name   = aws_db_parameter_group.demo-delete.name
  publicly_accessible    = true
  skip_final_snapshot    = true
}

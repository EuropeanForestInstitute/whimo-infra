locals {
  rds_env = var.create_prod_rds ? { prod = true } : {}
}

resource "aws_db_subnet_group" "prod" {
  for_each  = local.rds_env
  name      = "${var.project_name}-prod-db-subnets"
  subnet_ids = module.vpc.private_subnets
}

resource "aws_security_group" "rds" {
  for_each = local.rds_env
  name_prefix = "${var.project_name}-prod-db-"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ssh["prod"].id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "prod" {
  for_each               = local.rds_env
  identifier             = "${var.project_name}-prod-db"

  engine                 = var.rds_engine
  engine_version         = var.rds_engine_version
  instance_class         = var.rds_instance_class

  db_subnet_group_name   = aws_db_subnet_group.prod[each.key].name
  vpc_security_group_ids = [aws_security_group.rds[each.key].id]

  allocated_storage      = var.rds_allocated_storage
  storage_type           = "gp3"
  db_name                = var.rds_db_name
  username               = var.rds_username
  password               = random_password.rds_master.result

  storage_encrypted      = true
  publicly_accessible    = false
  multi_az               = false
  skip_final_snapshot    = true
  deletion_protection    = false
}

resource "random_password" "rds_master" {
  length           = 32
  special          = true
  min_upper        = 1
  min_lower        = 1
  min_numeric      = 1
  min_special      = 2
  override_special = "_%+-#="
}
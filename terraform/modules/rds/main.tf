resource "aws_db_subnet_group" "rds" {
  name       = "monster-rds-group"
  subnet_ids = var.subnet_ids
}

resource "aws_security_group" "rds" {
  name   = "rds-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "postgres" {
  identifier           = "monster-db"
  engine               = "postgres"
  engine_version       = "16.3" # <--- VERSÃO ATUALIZADA
  instance_class       = "db.t3.micro"
  allocated_storage     = 20
  db_name              = "master_db"
  username             = "postgres"
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.rds.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  publicly_accessible  = false
  skip_final_snapshot  = true
}
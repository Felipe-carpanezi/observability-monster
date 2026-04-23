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
    cidr_blocks = [var.vpc_cidr] # Permite acesso apenas de dentro da rede
  }
}

resource "aws_db_instance" "postgres" {
  identifier           = "monster-db"
  engine               = "postgres"
  engine_version       = "16.1"
  instance_class       = "db.t3.micro"
  allocated_storage     = 20
  db_name              = "master_db" # Banco inicial
  username             = "postgres"
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.rds.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  skip_final_snapshot  = true
}
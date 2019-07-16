resource "aws_db_instance" "postgres01" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "10.6"
  instance_class       = "db.t2.micro"
  name                 = "teste"
  username             = "teste"
  password             = "testando"
  skip_final_snapshot    = "true"
  db_subnet_group_name   = aws_db_subnet_group.sng01.id
  vpc_security_group_ids = [aws_security_group.sg01.id]
  publicly_accessible    = "true"
}

provider "postgresql" {
  host            = aws_db_instance.postgres01.endpoint
  port            = 5432
  database        = "postgres"
  username        = "teste"
  password        = "testando"
  connect_timeout = 15
}

resource "postgresql_database" "teste" {
  provider = "postgresql"
  name     = "testedb"
  depends_on = [aws_db_instance.postgres01]
}


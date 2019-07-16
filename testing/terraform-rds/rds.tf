resource "aws_db_instance" "rds01" {
  identifier             = "rds01-${var.db_name}"
  allocated_storage      = 10
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.small"
  name                   = var.rds_name
  username               = var.rds_user
  password               = var.rds_pass
  skip_final_snapshot    = "true"
  db_subnet_group_name   = aws_db_subnet_group.sng01.id
  vpc_security_group_ids = [aws_security_group.sg01.id]
  publicly_accessible    = "true"
#  lifecycle {
#    ignore_changes = [password]
#  }
}

output "RDS_real_endpoint" {
  value = aws_db_instance.rds01.address
}


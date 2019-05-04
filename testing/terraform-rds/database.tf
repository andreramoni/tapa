resource "aws_db_instance" "rds01" {
  identifier           = "rds01-${var.db_name}"
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.small"
  name                 = "${var.db_name}"
  username             = "${var.db_user}"
  password             = "${var.db_pass}"
  #final_snapshot_identifier = "infra-rundeck"
  skip_final_snapshot  = "true"
  db_subnet_group_name = "${aws_db_subnet_group.sng01.id}"
  vpc_security_group_ids = ["${aws_security_group.sg01.id}"] 

  lifecycle {
    ignore_changes = ["password"]
  }

}

output "RDS real endpoint" { value = "${aws_db_instance.rds01.address}" }


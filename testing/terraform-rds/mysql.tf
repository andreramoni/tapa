provider "mysql" {
  endpoint = aws_db_instance.rds01.endpoint
  username = var.rds_user
  password = var.rds_pass
}

#resource "mysql_database" "mysqldb" {
#  name = var.db_name
#}

#resource "mysql_user" "mysqluser" {
#  user               = var.db_user
#  host               = "*"
#  plaintext_password = var.db_pass
#}

#resource "mysql_grant" "mysqlgrant" {
#  user       = var.db_user
#  host       = "*"
#  database   = var.db_name
#  privileges = ["SELECT", "UPDATE"]
#}


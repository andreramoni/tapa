resource "aws_db_subnet_group" "sng01" {
  name       = "subnetgroup01"
  subnet_ids = ["${aws_subnet.subnet01.id}","${aws_subnet.subnet02.id}"]

  tags = {
    Name = "subnetgroup01"
  }
}

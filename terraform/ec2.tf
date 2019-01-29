resource "aws_instance" "app01" {
  ami                    = "${var.ami_id}"
  count                  = "${var.instance_count_desired}"  
  instance_type          = "${var.instance_type}"
  vpc_security_group_ids = [ "${aws_security_group.app01.id}" ]
  subnet_id              = "${aws_subnet.app01.id}"
  tags = {
    Name = "app01"
  }
}


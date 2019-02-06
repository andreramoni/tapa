resource "aws_instance" "i01" {
  ami                    = "ami-035be7bafff33b6b6"
  count                  = "1"  
  instance_type          = "t2.micro"
  vpc_security_group_ids = [ "${aws_security_group.sg01.id}" ]
  subnet_id              = "${aws_subnet.subnet01.id}"
  tags = {
    Name = "i01"
  }
}


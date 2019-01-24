resource "aws_instance" "i_app01-frontend" {
  ami           = "ami-051b4811c67117b1b"
  instance_type = "t2.micro"
  vpc_security_group_ids = [ "${aws_security_group.app01.id}" ]
  subnet_id      = "${aws_subnet.app01.id}"
  tags = {
    Name = "i-app01-frontend01"
  }
}

resource "aws_security_group" "buildsg01" {
  name = "buildsg01"
  vpc_id = "${aws_vpc.buildvpc01.id}"
  tags {
    name = "buildisg01"
  }
  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
 }
}



resource "aws_security_group" "sg_app01" {
  name = "sg_app01"
  vpc_id = "${aws_vpc.vpc_app01-prod.id}"
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


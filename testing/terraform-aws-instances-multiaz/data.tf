data "aws_subnet" "subnets" {
  id = "${aws_subnet.subnets.*.id}"
}

resource "aws_instance" "instance" {
  count         = 1
  ami           = "${var.ami}"
  instance_type = "${var.instance_type}"
  monitoring    = "true"

  vpc_security_group_ids = [
    "${aws_security_group.sg.id}"
  ]

  subnet_id = "${data.aws_subnet.subnets.id[count.index % 2]}"
  root_block_device {
    volume_type = "gp2"
    volume_size = "30"
  }

  tags {
    Name        = "instance"
  }
}
#output "private_ip" { value = "${aws_instance.infra-sitarq.private_ip}" }
#output "public_ip" { value = "${aws_instance.infra-sitarq.public_ip}" }


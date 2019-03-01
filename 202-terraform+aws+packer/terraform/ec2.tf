resource "aws_instance" "i01" {
  ami                    = "${data.aws_ami.app01_ami.id}" 
  count                  = "1"  
  key_name               = "${aws_key_pair.kp01.id}"
  instance_type          = "${var.instance_type}"
  vpc_security_group_ids = [ "${aws_security_group.sg01.id}" ]
  subnet_id              = "${aws_subnet.subnet01.id}"
  tags = {
    Name = "i01"
  }
}
output "private_ip" { value = "${aws_instance.i01.private_ip}" }
output "public_ip"  { value = "${aws_instance.i01.public_ip}" }



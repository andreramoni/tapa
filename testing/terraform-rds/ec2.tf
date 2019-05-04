resource "aws_instance" "i01" {
  # Amazon linux in us-east-1: ami-035be7bafff33b6b6
  # CentOS 7 in us-east-1: ami-4bf3d731
  ami                    = "ami-4bf3d731" 
  count                  = "1"  
  key_name               = "${aws_key_pair.kp01tmp.id}"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [ "${aws_security_group.sg01.id}" ]
  subnet_id              = "${aws_subnet.subnet01.id}"
  tags = {
    Name = "i01"
  }
}
output "private_ip" { value = "${aws_instance.i01.private_ip}" }
output "public_ip" { value = "${aws_instance.i01.public_ip}" }



data "aws_ami" "MyAMI" {
  most_recent = true

  filter {
    name   = "name"
    values = ["MyAMI*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["self"] # Canonical
}

resource "aws_instance" "i01" {
  # Amazon linux in us-east-1: ami-035be7bafff33b6b6
  ami                    = "${data.aws_ami.MyAMI.id}" 
  count                  = "1"  
  instance_type          = "t2.micro"
  vpc_security_group_ids = [ "${aws_security_group.sg01.id}" ]
  subnet_id              = "${aws_subnet.subnet01.id}"
  tags = {
    Name = "i01"
  }
}
output "private_ip" { value = "${aws_instance.i01.private_ip}" }
output "public_ip" { value = "${aws_instance.i01.public_ip}" }



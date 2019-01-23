#### VPCs
resource "aws_vpc" "app01" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags {
    Name = "app01"
  }
}
output "vpc_id" { value = "${aws_vpc.app01.id}" }

#### Subnets
resource "aws_subnet" "app01" {
  vpc_id                  = "${aws_vpc.app01.id}"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"
  tags {
    Name = "app01-az1"
  }
}
output "subnet_id" { value = "${aws_subnet.app01.id}" }

#### Internet gateways
## IG prod
resource "aws_internet_gateway" "app01" {
  vpc_id = "${aws_vpc.app01.id}"
  tags {
    Name = "app01"
  }
}

#### Route tables
resource "aws_route_table" "app01" {
  vpc_id = "${aws_vpc.app01.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.app01.id}"
  }
  tags {
    Name = "app01"
  }
}

resource "aws_route_table_association" "app01" {
  subnet_id      = "${aws_subnet.app01.id}"
  route_table_id = "${aws_route_table.app01.id}"
}


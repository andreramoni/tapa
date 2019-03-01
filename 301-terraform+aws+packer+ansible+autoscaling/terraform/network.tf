#### VPCs
resource "aws_vpc" "vpc01" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags {
    Name = "vpc01"
  }
}
output "vpc_id" { value = "${aws_vpc.vpc01.id}" }

#### Subnets
resource "aws_subnet" "subnet01" {
  vpc_id                  = "${aws_vpc.vpc01.id}"
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags {
    Name = "subnet01"
  }
}
output "subnet01_id" { value = "${aws_subnet.subnet01.id}" }

resource "aws_subnet" "subnet02" {
  vpc_id                  = "${aws_vpc.vpc01.id}"
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags {
    Name = "subnet02"
  }
}
output "subnet02_id" { value = "${aws_subnet.subnet02.id}" }

#### Internet gateways
## IG prod
resource "aws_internet_gateway" "ig01" {
  vpc_id = "${aws_vpc.vpc01.id}"
  tags {
    Name = "ig01"
  }
}

#### Route tables
resource "aws_route_table" "rt01" {
  vpc_id = "${aws_vpc.vpc01.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.ig01.id}"
  }
  tags {
    Name = "rt01"
  }
}

resource "aws_route_table_association" "rta01" {
  subnet_id      = "${aws_subnet.subnet01.id}"
  route_table_id = "${aws_route_table.rt01.id}"
}
resource "aws_route_table_association" "rta02" {
  subnet_id      = "${aws_subnet.subnet02.id}"
  route_table_id = "${aws_route_table.rt01.id}"
}


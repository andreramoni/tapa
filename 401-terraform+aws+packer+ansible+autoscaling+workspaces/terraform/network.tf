#### VPCs
resource "aws_vpc" "vpc01" {
  cidr_block           = "${var.vpc_cidr["${terraform.workspace}"]}"
  enable_dns_hostnames = true
  tags {
    Name = "vpc01"
  }
}
output "vpc_id" { value = "${aws_vpc.vpc01.id}" }

#### Subnets
resource "aws_subnet" "subnet01" {
  vpc_id                  = "${aws_vpc.vpc01.id}"
  cidr_block              = "${element(var.subnet_cidr["${terraform.workspace}"], 0)}"
  availability_zone       = "${element(var.zones["${terraform.workspace}"], 0)}"
  map_public_ip_on_launch = true
  tags {
    Name = "subnet01"
  }
}
output "subnet01_id" { value = "${aws_subnet.subnet01.id}" }

resource "aws_subnet" "subnet02" {
  vpc_id                  = "${aws_vpc.vpc01.id}"
  cidr_block              = "${element(var.subnet_cidr["${terraform.workspace}"], 1)}"
  availability_zone       = "${element(var.zones["${terraform.workspace}"], 1)}"
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


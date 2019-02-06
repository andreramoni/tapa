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
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true
  tags {
    Name = "subnet01"
  }
}
output "subnet_id" { value = "${aws_subnet.subnet01.id}" }

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


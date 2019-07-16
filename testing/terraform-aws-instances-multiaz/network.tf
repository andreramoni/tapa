#### VPCs
resource "aws_vpc" "vpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  tags {
    Name = "vpc"
  }
}
output "vpc_id" { value = "${aws_vpc.vpc.id}" }

#### Subnets
resource "aws_subnet" "subnets" {
  count                   = 2
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.subnet_cidr[count.index]}"
  availability_zone       = "${var.az[count.index]}"
  map_public_ip_on_launch = true
  tags {
    Name = "subnet-0${count.index}"
  }
}
output "subnet_ids" { value = "${aws_subnet.subnets.*.id}" }

#### Internet gateways
## IG prod
resource "aws_internet_gateway" "ig" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags {
    Name = "ig"
  }
}

#### Route tables
resource "aws_route_table" "rt" {
  vpc_id = "${aws_vpc.vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.ig.id}"
  }
  tags {
    Name = "rt"
  }
}

#resource "aws_route_table_association" "rta" {
#  count = 2
#  subnet_id      = "${aws_subnet.subnets.count.index.id}"
#  route_table_id = "${aws_route_table.rt.id}"
#}
#resource "aws_route_table_association" "rta02" {
#  subnet_id      = "${aws_subnet.subnet02.id}"
#  route_table_id = "${aws_route_table.rt.id}"
#}


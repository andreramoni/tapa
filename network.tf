resource "aws_vpc" "vpc_app01-prod" {
  cidr_block           = "10.1.0.0/16"
  enable_dns_hostnames = true

  tags {
    Name = "vpc_app01-prod"
  }
}

resource "aws_subnet" "subnet_app01-prod_1a" {
  vpc_id                  = "${aws_vpc.vpc_app01-prod.id}"
  cidr_block              = "10.1.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"
  tags {
    Name = "subnet_app01-prod_1a"
  }
}

resource "aws_subnet" "subnet_app01-prod_1c" {
  vpc_id                  = "${aws_vpc.vpc_app01-prod.id}"
  cidr_block              = "10.1.2.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1c"
  tags {
    Name = "subnet_app01-prod_1c"
  }
}

resource "aws_internet_gateway" "ig_app01-prod" {
  vpc_id = "${aws_vpc.vpc_app01-prod.id}"
  tags {
    Name = "ig_app01-prod"
  }
}

resource "aws_route_table" "rt_app01-prod" {
  vpc_id = "${aws_vpc.vpc_app01-prod.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.ig_app01-prod.id}"
  }
  tags {
    Name = "rt_app01-prod"
  }
}

resource "aws_route_table_association" "rta_app01-prod_1a" {
  subnet_id      = "${aws_subnet.subnet_app01-prod_1a.id}"
  route_table_id = "${aws_route_table.rt_app01-prod.id}"
}

resource "aws_route_table_association" "rta_app01-prod_1c" {
  subnet_id      = "${aws_subnet.subnet_app01-prod_1c.id}"
  route_table_id = "${aws_route_table.rt_app01-prod.id}"
}


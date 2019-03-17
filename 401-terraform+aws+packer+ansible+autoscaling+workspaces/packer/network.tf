#### VPCs
resource "aws_vpc" "buildvpc01" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags {
    name = "buildvpc01"
  }
}
output "vpc_id" { value = "${aws_vpc.buildvpc01.id}" }

#### Subnets
resource "aws_subnet" "buildsubnet01" {
  vpc_id                  = "${aws_vpc.buildvpc01.id}"
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true
  tags {
    name = "buildsubnet01"
  }
}
output "subnet_id" { value = "${aws_subnet.buildsubnet01.id}" }

#### Internet gateways
## IG prod
resource "aws_internet_gateway" "buildig01" {
  vpc_id = "${aws_vpc.buildvpc01.id}"
  tags {
    Name = "buildig01"
  }
}

#### Route tables
resource "aws_route_table" "buildrt01" {
  vpc_id = "${aws_vpc.buildvpc01.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.buildig01.id}"
  }
  tags {
    Name = "buildrt01"
  }
}

resource "aws_route_table_association" "buildrta01" {
  subnet_id      = "${aws_subnet.buildsubnet01.id}"
  route_table_id = "${aws_route_table.buildrt01.id}"
}


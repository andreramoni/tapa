variable "ami_id" {}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "region" {}

variable "subnet_cidr" {
  default = "10.0.0.0/24"
}


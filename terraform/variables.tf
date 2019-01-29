variable "ami_id" {
  default = ""
}

variable "instance_type" { 
  default = "t2.micro"
} 

variable "instance_count_desired" { 
  default = "0"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "subnet_cidr" {
  default = "10.0.0.0/24"
}

variable "region" {
  default = "us-east-2"
}



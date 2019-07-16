variable "vpc_id" {
	default = ""
}

variable "region" {
	default = "us-east-1"
}
variable "ami" {
	default = "ami-4bf3d731"
}

variable "instance_type" {
	default = "t2.micro"
}

variable "subnet_cidr" {
	type = "list"
	default = [ "10.0.1.0/24", "10.0.2.0/24" ] 
}

variable "subnet_ids" { default = "" }

variable "az" {
	type = "list"
	default = [ "us-east-1a", "us-east-1b" ] 
}

variable "vpc_cidr" {
	default = "10.0.0.0/16" 
}



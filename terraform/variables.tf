variable "app" {
  type = "string"
  default = "app01"
}

variable "env" {
  type = "string"
  default = "stg"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}



variable "zone" {
  type = "map"
  default = {
    stg = "us-east-1"
  }
}

variable "subnet_cidr" {
  type = "map"
  default = {
    az1 = "10.0.1.0/24"
    az2 = "10.0.2.0/24"
  }
}

#variable "zones" {
#  default = ["us-east-1a", "us-east-1b"]
#}

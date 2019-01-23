variable "app" {
  type = "string"
  default = "app01"
}

variable "env" {
  type = "string"
  default = "stg"
}


variable "vpc_cidr" {
  type = "map"
  default = {
    stg = "10.0.0.0/24"
    prd = "10.0.0.0/16"
  }
}

#variable "zones" {
#  default = ["us-east-1a", "us-east-1b"]
#}

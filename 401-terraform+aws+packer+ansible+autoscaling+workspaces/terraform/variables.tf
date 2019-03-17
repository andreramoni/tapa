variable "instance_type" {
  default = "t2.micro"
}
variable "vpc_cidr" {
  type = "map"
  default = {
    dev = "10.1.0.0/16"
    stg = "10.2.0.0/16"
    prd1 = "10.11.0.0/16"
    prd2 = "10.12.0.0/16"
  }
}
variable "subnet_cidr" {
  type = "map"
  default = {
    dev =  [ "10.1.1.0/24", "10.1.2.0/24"  ]
    stg =  [ "10.2.1.0/24", "10.2.2.0/24"  ]
    prd1 = [ "10.11.1.0/24", "10.11.2.0/24"  ]
    prd2 = [ "10.12.1.0/24", "10.12.2.0/24"  ]
  }
}

variable "region" {
  type = "map"
  default = {
    dev = "us-east-1"
    stg = "us-east-1"
    prd1 = "sa-east-1"
    prd2 = "us-east-1"
  }
}

variable "zones" {
  type = "map"
  default = {
    dev = ["us-east-1a", "us-east-1b"]
    stg = ["us-east-1a", "us-east-1b"]
    prd1 = ["sa-east-1a", "sa-east-1c"]
    prd2 = ["us-east-1a", "us-east-1b"]
  }
}



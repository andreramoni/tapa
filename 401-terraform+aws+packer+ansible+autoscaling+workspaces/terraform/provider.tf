provider "aws" {
## Leave commented to use environment variables
## Or uncomment and populate with your keys
#  access_key = ""
#  secret_key = ""
  region     = "${var.region["${terraform.workspace}"]}"
}


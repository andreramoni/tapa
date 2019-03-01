#!/bin/bash
terraform apply -auto-approve
packer build build-ami.json
terraform destroy -auto-approve
rm -f *tfstate*


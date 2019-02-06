You should export your access key and secret id before using.
Do that by exporting these variables:
(DO NOT SAVE THEM IN A FILE)

export AWS_ACCESS_KEY_ID=""               
export AWS_SECRET_ACCESS_KEY=""

First, build a new AMI with packer.
Enter the packer dir and do:

packer build build-ami.json

It will create a new instance based on amazon linux,
execute the provision.sh script inside it, 
and create a new image.


After that, you can use terraform:

terraform init    # first time use only
terraform plan    # To see what it will do
terraform apply   # To really apply it
terraform destroy # To destroy everything created.

Terraform will always use the most recent AMI created by packer.


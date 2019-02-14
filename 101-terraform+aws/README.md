You should export your access key and secret id before using.
Do that by exporting these variables:
(DO NOT SAVE THEM IN A FILE)

export AWS_ACCESS_KEY_ID=""               
export AWS_SECRET_ACCESS_KEY=""

After that, you can use terraform:

terraform init    # first time use only
terraform plan    # To see what it will do
terraform apply   # To really apply it
terraform destroy # To destroy everything created.

Try changing the ami in ec2.tf and apply.
It should replace the instance.

Resources used:
aws_instance
aws_vpc
aws_subnet
aws_internet_gateway
aws_route_table
aws_route_table_association
aws_security_group
aws_key_pair






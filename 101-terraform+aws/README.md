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


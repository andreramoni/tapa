Now we're going to bring up the build environment 
from ground up instead of using the default vpc.

We'll use terraform (of course) to bring up the vpc, 
subnet, secgroup etc, but not an instance.

The instance will be created by packer.

So, the steps are:

Bring up the basic infrastructure:
terraform apply

Run packer:
packer build build-centos.json

Destroy the build environment:
terraform destroy





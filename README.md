# iac
The idea is to create a remarkable orquestration using as many as possible tools.
The goal is to use:
- Ansible
- Puppet
- Packer
- Terraform
- Foreman
- Git

These tools must be used together to create a full functioning workload from scratch.

#Inicial plan

Terraform creates a CentOS EC2 instance.
Ansible do the initial tunning.
Packer creates an AMI from it.
Terraform creates a new EC2 instance based on the new image and installs Foreman.
Ansible do the entire foreman configuration, including adding AWS compute resource.
Ansible install puppet modules on foreman.
Ansible uses Foreman API to create new hosts.
New hosts get configured by Puppet.


#Services:
Haproxy (x2)
NGinx (x2)

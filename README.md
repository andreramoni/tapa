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

- Puppet creates a CentOS EC2 instance.
- Ansible do the initial tunning.
- Packer creates an AMI from it.
- Puppet creates a new EC2 instance based on the new image and installs Foreman.
- Ansible do the entire foreman configuration, including adding AWS compute resource.
- Ansible install puppet modules on foreman.
- Ansible uses Foreman API to create new hosts.
- New hosts get configured by Puppet.
Up and running.

#New release deploy
- New release on github repo.
- GoCD builds a new .rpm and put it on the repo
- Mcollective stops puppet agents on app servers
- Mcollective do the upgrade 1 by 1 with some interval
- GoCD changes the version in puppet parameter
- mcollective starts the puppet agent 



#Services:
- Haproxy (x2)
- NGinx (x2)

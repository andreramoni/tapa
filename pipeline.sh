#!/bin/bash

# Helper script to manage pipeline stages


# Vars:
export TFDIR="terraform"
export PACKERDIR="packer"
export PACKERFILE="build-ami.json"
export TMPFILE="/tmp/pipeline-$RANDOM.tmp"

#export AWS_VPC_ID=""
#export AWS_SUBNET_ID=""


#############################################################
## Basic functions:

# Usage instructions:
function f_usage() {
  echo help
  exit 1
}

# Error function:
function f_error() {
  echo "$1"
  exit $2
}

# Say function:
function f_say() {
  echo "[pipeline]: $1"
}

# arg eval:
function f_main(){
  case $1 in
    build-image)       f_build_image ;;
    deploy-staging)    f_deploy staging ;;
    deploy-production) f_deploy production ;;
    *)                 f_usage ; exit 1 ;;
  esac
}
#############################################################
# Build image:
# terraform plan/apply -> packer -> ansible -> terraform destroy
# Output: AMI ID
function f_build_image() {
  cd $TFDIR        || f_error "Cannot chdir to $TFDIR."
  #terraform plan   || f_error "Error in terraform plan"
  terraform apply  |  tee $TMPFILE
  export AWS_SUBNET_ID=$(cat $TMPFILE | grep 'subnet_id = ' | awk '{print $3}') 
  export AWS_VPC_ID=$(cat $TMPFILE | grep 'vpc_id = ' | awk '{print $3}') 
  f_say "AWS_SUBNET_ID=$AWS_SUBNET_ID"
  f_say "AWS_VPC_ID=$AWS_VPC_ID"
  echo "$AWS_VPC_ID" > /tmp/id
  cd ../$PACKERDIR || f_error "Cannot chdir to $PACKERDIR."
  f_say "Packer validate:"
  packer validate $PACKERFILE || f_error "Error on packer validate."
  f_say "Packer build:"
  packer build -var aws_vpc_id=vpc-0a77a4467fb40abbe $PACKERFILE 
}












#############################################################
# clean up:
function f_cleanup() {
  f_say "Removing temp file $TMPFILE:"
  rm -vf $TMPFILE
}

#############################################################
# program start:
f_main $@
f_cleanup


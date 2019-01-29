#!/bin/bash

# Helper script to manage pipeline stages


# Vars:
export TFDIR="terraform"
export PACKERDIR="packer"
export PACKERFILE="build-ami.json"
export TMPFILE="/tmp/pipeline-$RANDOM.tmp"
export AWS_REGION="$AWS_DEFAULT_REGION"
#export AWS_VPC_ID=""
#export AWS_SUBNET_ID=""


#############################################################
## Basic functions:

# Usage instructions:
function f_usage() {
  echo
  echo "Usage:"
  echo "  $0 <stage>"
  echo
  echo "Stage can be:"
  echo "  build-image       -> To build the new image"
  echo "  deploy-staging    -> To deploy the image on staging"
  echo "  deploy-production -> To deploy the image on production"
  echo
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
    *)                 f_say "stage $1 not found" ; f_usage ; exit 1 ;;
  esac
}
#############################################################
# Build image:
# terraform plan/apply -> packer -> ansible -> terraform destroy
# Output: AMI ID
function f_build_image() {
  cd $TFDIR        || f_error "Cannot chdir to $TFDIR."
  f_say "Terraform plan:"
  terraform plan  -no-color  || f_error "Error in terraform plan"
  f_say "Terraform apply:"
  terraform apply -no-color -auto-approve |  tee $TMPFILE
  export AWS_VPC_ID=$(cat $TMPFILE | expand | grep 'vpc_id = ' | awk '{print $3}')
  export AWS_SUBNET_ID=$(cat $TMPFILE | expand | grep 'subnet_id = ' | awk '{print $3}') 
  f_say "Terraform created VPC_ID=$AWS_VPC_ID."
  f_say "Terraform created SUBNET_ID=$AWS_SUBNET_ID."
  cd ../$PACKERDIR || f_error "Cannot chdir to $PACKERDIR."
  f_say "Packer validate:"
  packer validate $PACKERFILE || f_error "Error validating packer file." 
  f_say "Packer build:"
  packer build -color=false $PACKERFILE | tee $TMPFILE
  NEW_AMI_ID=$(cat $TMPFILE | grep ^"$AWS_REGION" | awk '{print $2}' )
  f_say "Packer created NEW_AMI_ID=$NEW_AMI_ID"
  f_say "Terraform destroy:"
  cd ../$TFDIR
  terraform destroy -auto-approve -no-color
  f_say "Packer created NEW_AMI_ID=$NEW_AMI_ID"

}










#############################################################
# pre-flight:
function f_preflight() {
  # check terraform, packer and ansible
  f_say "Preflight checking..."

  TFBIN=$(which terraform) || f_error "Terraform not found"
  TFVER=$($TFBIN -version | head -n1)
  f_say "Terraform: $TFBIN ($TFVER)"
  
  PACKERBIN=$(which packer) || f_error "Packer not found"
  PACKERVER=$($PACKERBIN -version | head -n1)
  f_say "Packer:    $PACKERBIN    ($PACKERVER)"
  
  # check env vars
   
}




#############################################################
# clean up:
function f_cleanup() {
  f_say "Removing temp file $TMPFILE:"
  rm -vf $TMPFILE
}

#############################################################
# program start:
f_preflight
f_main $@
f_cleanup


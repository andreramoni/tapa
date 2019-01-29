#!/bin/bash

# Helper script to manage pipeline stages

# Vars:
export TFDIR="terraform"
export PACKERDIR="packer"
export PACKERFILE="build-ami.json"
export TMPFILE="/tmp/pipeline-$RANDOM.tmp"
export AWS_REGION="$AWS_DEFAULT_REGION"
export DATADIR="data"
export DATA_LATEST_AMI="$DATADIR/latest_ami.txt"

#############################################################
## Basic functions:

# Usage instructions:
function f_usage() {
  echo
  echo "Usage:"
  echo "  $0 <action>"
  echo
  echo "Action can be:"
  echo "  build                -> To build the new image"
  echo "  deploy <environment> -> To deploy the image on <environment>"
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
    build)       export ENV="$1" ; f_build ;;
    deploy)      export ENV="$2" ; f_deploy;;
    *)           f_say "stage \"$1\" not found" ; f_usage ; exit 1 ;;
  esac
}
#############################################################
# Build image:
# terraform plan/apply -> packer -> ansible -> terraform destroy
# Output: AMI ID
function f_build() {
  f_preflight
  f_vardump
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
  cd ..
  NEW_AMI_ID=$(cat $TMPFILE | grep ^"$AWS_REGION" | awk '{print $2}' )
  f_say "Packer created NEW_AMI_ID=$NEW_AMI_ID (saving to $DATA_LATEST_AMI)."
  echo $NEW_AMI_ID > $DATA_LATEST_AMI
  f_say "Terraform destroy:"
  cd $TFDIR
  terraform destroy -auto-approve -no-color
  f_say "Packer created NEW_AMI_ID=$NEW_AMI_ID"

}

function f_deploy(){
  f_preflight
  f_vardump
  AWS_AMI_ID=$(cat $DATA_LATEST_AMI)
  f_say "Latest AMI: $AWS_AMI_ID"
  cd $TFDIR        || f_error "Cannot chdir to $TFDIR."
  export TF_VAR_ami_id=$AWS_AMI_ID
  export TF_VAR_region=$AWS_REGION
}
#############################################################
# pre-flight:
function f_preflight() {
  f_say "Preflight checking..." 
  if [ "$ENV" == "" ]; then
    f_error "Environment cannot be blank"
  fi
  source environments/$ENV || f_error "Cannot parse environments/$ENV variables file."

  # Terraform
  cd $TFDIR
  $TFBIN init
  if [ "`$TFBIN workspace list | grep $ENV`" == "" ]; then
    f_say "Terraform: creating workspace $ENV"
    $TFBIN workspace new $ENV
  else
    f_say "Terraform: select workspace $ENV"
    $TFBIN workspace select $ENV
  fi
  cd ..
  export TF_VAR_region=$AWS_REGION
  
}

# var dump
function f_vardump() {
  f_say "----- vars -----"
  f_say "ARG1=$1"
  f_say "ARG2=$2"
  f_say "PWD=$PWD"
  f_say "TFBIN=$TFBIN"
  f_say "TFDIR=$TFDIR"
  f_say "PACKERBIN=$PACKERBIN"
  f_say "PACKERDIR=$PACKERDIR"
  f_say "ENV=$ENV"
  f_say "AWS_REGION=$AWS_REGION"
  f_say "AWS_INSTANCE_TYPE=$AWS_INSTANCE_TYPE"
  f_say "AWS_AMI_ID=$AWS_AMI_ID"
  f_say "AWS_VPC_ID=$AWS_VPC_ID"
  f_say "AWS_SUBNET_ID=$AWS_SUBNET_ID"
  f_say "----- vars -----"

}

# pre-reqs:
function f_prereqs() {
  # check terraform, packer and ansible
  f_say "Prereqs checking..."

  TFBIN=$(which terraform) || f_error "Terraform not found"
  TFVER=$($TFBIN -version | head -n1)
  f_say "Terraform: $TFBIN ($TFVER)"
  
  PACKERBIN=$(which packer) || f_error "Packer not found"
  PACKERVER=$($PACKERBIN -version | head -n1)
  f_say "Packer:    $PACKERBIN    ($PACKERVER)"

  test -d "$DATADIR" || mkdir $DATADIR
  
  # check env vars
   
}

#############################################################
# clean up:
function f_cleanup() {
  f_say "Cleaning up..."
  f_say "Removing temp file $TMPFILE:"
  rm -vf $TMPFILE
 
  # Reset to default workspace 
  cd $TFDIR
  $TFBIN workspace select default
  cd ..
}

#############################################################
# program start:
f_prereqs
f_main $@
f_cleanup


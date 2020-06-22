#!/bin/bash

if test -z $1
then
  echo "You must specify TFVARS service definition file. For example \"./new-service.sh services/customer-service.tfvars"
else
  dir="svc_"`echo $1 | awk -F'/' '{print $NF}' | cut -d "." -f 1`
  file=`echo $1 | awk -F'/' '{print $NF}'`

# Test if service directory exists. If so, delete the content
  if test -d $dir
  then
    echo "Service directory exists. Deleting ..."
    rm $dir/*.*
  else
    mkdir $dir
  fi

# Prepare new service directory (all *.tf files, tfvars from existing environment and service definition)
  terraform output | sed 's/= */= "/' | sed 's/$/"/' | sed 's/"\["/\[/' | sed 's/\]"/\]/' | sed 's/,"/,/' > $dir/terraform.tfvars
  cp new-service.tf/*.* $dir
  cp $1 $dir

# Run terraform init and apply
  cd $dir
  terraform init
  terraform apply -var-file="$file"
fi

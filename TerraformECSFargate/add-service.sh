#!/bin/bash

# check if .services directory exists
svcdir=".services"
if ! test -d $svcdir
then
  echo "$svcdir doesn't exists. Creating ..."
  mkdir $svcdir
fi

if test -z $1
then
  echo "You must specify TFVARS service definition file. For example \"./new-service.sh services/customer-service.tfvars"
else
  file=`echo $1 | awk -F'/' '{print $NF}'`
  dir="$svcdir/"`echo svc_$file | cut -d "." -f 1`

# Test if service directory exists. If so, delete the content
  if test -d $dir
  then
    echo "Service directory exists. Deleting ..."
    rm $dir/*
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

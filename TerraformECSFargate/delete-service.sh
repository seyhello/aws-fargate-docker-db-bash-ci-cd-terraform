#!/bin/bash

if test -z $1
then
  echo "You must specify service name. For example \"./delete-service.sh customer-service"
else
  dir="svc_"`echo $1`

# Test if service directory exists. If so, delete the content
  if test -d $dir
  then
    echo "OK, service $1 exists. Destroying ..."
    cd $dir
    terraform destroy -var-file="$1.tfvars"
    cd ..
    rm -r $dir
  else
    echo "Service $1 doesn't exists."
  fi
fi

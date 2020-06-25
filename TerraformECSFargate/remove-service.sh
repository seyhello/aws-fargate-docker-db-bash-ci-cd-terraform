#!/bin/bash

### Removes service from the cluster

# check if .services directory exists
svcdir=".services"
if ! test -d $svcdir
then
  echo "No services deployed ($svcdir directory doesn't exists). Terminating script ..."
  exit 1
fi

if test -z $1
then
  echo "Please specify service name: "
  read service
else
  service=$1
fi

dir="$svcdir/svc_$service"

# Test if service directory exists. If so, delete the content
if test -d $dir
then
  echo "OK, service $service exists. Destroying ..."
  cd $dir
  terraform destroy -var-file="$service.tfvars"
  cd ../..
  rm -r $dir
else
  echo "Service $service doesn't exists."
  exit 1
fi

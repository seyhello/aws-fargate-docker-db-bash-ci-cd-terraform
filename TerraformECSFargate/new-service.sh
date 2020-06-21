#!/bin/bash

if test -z $1
then
  echo "You must specify TFVARS service definition file. For example \"./new-service.sh services/customer-service.tfvars"
else
  terraform output > newservice.tfvars
  cat newservice.tfvars | sed 's/= */= "/' | sed 's/$/"/' | sed 's/"\["/\[/' | sed 's/\]"/\]/' | sed 's/,"/,/' > terraform.tfvars
  rm newservice.tfvars

  dir="svc_"`echo $1 | awk -F'/' '{print $NF}' | cut -d "." -f 1`
  file=`echo $1 | awk -F'/' '{print $NF}'`
  mkdir $dir
  cd $dir

  cp ../new-service/*.tf .
  cp ../new-service/*.json .
  cp ../$1 .
  mv ../terraform.tfvars .

  terraform init
  terraform apply -var-file="$file"
fi

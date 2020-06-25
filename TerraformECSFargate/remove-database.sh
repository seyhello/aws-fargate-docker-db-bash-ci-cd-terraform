#!/bin/bash

### Removes database from the cluster

# check if .services directory exists
svcdir=".databases"
if ! test -d $svcdir
then
  echo "No databases deployed ($svcdir directory doesn't exists). Terminating script ..."
  exit 1
fi

if test -z $1
then
  echo "Please specify database id: "
  read service
else
  service=$1
fi

dir="$svcdir/$service"

# Test if service directory exists. If so, delete the content
if test -d $dir
then
  echo "OK, database $service exists. Destroying ..."
  cd $dir
  terraform destroy -var="database_id=$service" -var="database_name=unknown" -var="database_username=unknown" -var="database_password=unknown"
  cd ../..
  rm -r $dir
else
  echo "Database $service doesn't exists."
  exit 1
fi

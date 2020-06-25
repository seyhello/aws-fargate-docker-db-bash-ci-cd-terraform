#!/bin/bash

# check if .services directory exists
svcdir=".databases"
if ! test -d $svcdir
then
  echo "$svcdir doesn't exists. Creating ..."
  mkdir $svcdir
fi

echo "Please specify database ID (lowercase characters only): "
read database_id
echo "Please specify database name (lowercase characters only): "
read database_name
echo "Please specify database user (lowercase characters only): "
read database_user
echo "Please specify database password (min 8 characters length): "
read database_passwd

dir="$svcdir/$database_id"

# Test if database directory exists. If so, delete the content
if test -d $dir
then
  echo "Database directory exists. Deleting ..."
  rm $dir/*
else
  mkdir $dir
fi

# Prepare new database directory (all *.tf files, tfvars from existing environment and service definition)
terraform output | sed 's/= */= "/' | sed 's/$/"/' | sed 's/"\["/\[/' | sed 's/\]"/\]/' | sed 's/,"/,/' > $dir/terraform.tfvars

{
  echo "database_id = \"$database_id\""
  echo "database_name = \"$database_name\""
  echo "database_username = \"$database_user\""
  echo "database_password = \"$database_passwd\""
  echo "vpc_name = \"$database_id\""
} >> $dir/terraform.tfvars

cp new-db.tf/* $dir

# Run terraform init and apply
cd $dir
terraform init
terraform apply

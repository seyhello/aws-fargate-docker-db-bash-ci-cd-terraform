#!/bin/bash

echo "Service A (NGINX) is running..."

exec nginx -g "daemon off;"

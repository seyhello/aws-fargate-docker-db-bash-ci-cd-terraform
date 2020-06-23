#!/bin/bash

echo "Service A is running..."

exec nginx -g "daemon off;"

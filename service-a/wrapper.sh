#!/bin/bash

echo "Service A (nginx) is running..."

exec nginx -g "daemon off;"

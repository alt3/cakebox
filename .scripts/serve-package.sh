#!/usr/bin/env bash

# Check for required parameter
if [ -z "$1" ]
  then
    echo "Error: missing required parameter."
    echo "Usage: "
    echo " serve-package name"
    exit 1
fi

# Vagrant provisioning feedback
echo "Installing additional package $1"

# Install the package
DEBIAN_FRONTEND=noninteractive apt-get install -qq -y $1

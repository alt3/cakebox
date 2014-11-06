#!/usr/bin/env bash

# Define script usage
read -r -d '' USAGE <<-'EOF'
Installs additional software from the Ubuntu Pacakge archive.

Usage: cakebox-package [NAME]

    NAME: name of the software package (as used by `apt-get install`)
EOF

# Check for required parameter
if [ -z "$1" ]
  then
    printf "\n$USAGE\n\nError: missing required parameter.\n\n"
    exit 1
fi

# Vagrant provisioning feedback
echo "Installing additional package $1"

# Install the package
DEBIAN_FRONTEND=noninteractive apt-get install -qq -y $1

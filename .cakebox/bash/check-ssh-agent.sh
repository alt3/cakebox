#!/usr/bin/env bash

source /cakebox/bash/logger.sh

SCRIPTENTRY

printf %63s |tr " " "-"
printf '\n'
printf "Sanity checking SSH Agent Forwarding\n"
INFO "Sanity checking SSH Agent Forwarding"
printf %63s |tr " " "-"
printf '\n'

# Show user
USER=$(whoami 2>&1)
echo "Running checks as user $USER"

INFO "Running checks as user $USER"

# Show status of SSH Agent
echo "SSH Agent details:"
OUTPUT=$(ssh-agent 2>&1)
IFS=' ' read -a lines <<< "$OUTPUT"
for line in "${lines[@]}"
do
    echo "=> $line"
done

INFO "SSH Agent details: ($OUTPUT)"

# Show loaded keys
echo "SSH Forwarded keys:"
OUTPUT=$(ssh-add -l 2>&1)
EXITCODE=$?
echo "=> $OUTPUT"

INFO "SSH Forwarded keys: ($OUTPUT)"

SCRIPTEXIT
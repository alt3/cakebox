#!/usr/bin/env bash

IP=$1
PROTOCOL=$2

printf %63s |tr " " "-"
printf '\n'
printf "Your box is ready and waiting at %s://%s\n" "$PROTOCOL" "$IP"
printf %63s |tr " " "-"
printf '\n'

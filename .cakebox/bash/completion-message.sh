#!/usr/bin/env bash

IP=$1
PROTOCOL=$2

printf %63s |tr " " "-"
printf '\n'
printf "Your Cakebox is waiting at %s://%s\n" "$PROTOCOL" "$IP"
printf %63s |tr " " "-"
printf '\n'

#!/usr/bin/env bash

IP=$1

echo " "
printf %63s |tr " " "="
printf '\n'
printf "Your Cakebox is ready and waiting at https://%s\n" "$IP"
printf %63s |tr " " "="
printf '\n'

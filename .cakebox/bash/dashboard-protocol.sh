#!/usr/bin/env bash

PROTOCOL=$1
OUTPUT=$(/cakebox/console/bin/cake config dashboard --protocol "$PROTOCOL" 2>&1)
EXITCODE=$?
if [ "$EXITCODE" -ne 0 ]; then
	echo $OUTPUT
	echo "FATAL: error setting Cakebox Dashboard protocol to $PROTOCOL"
	exit 1
fi

# Show
echo "=> Cakebox Dashboard protocol set to $PROTOCOL"

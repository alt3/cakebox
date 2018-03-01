#!/usr/bin/env bash

SCRIPT_LOG=/var/log/cakephp/cakebox.cli.log

## Given a timestamp, message, and tag generate a LogStash Log
function generate_log() {
    declare -A logArray
    logArray[timestamp]="\"$1\""
    logArray[source]='"cakebox"'
    logArray[fields]="{\"channel\":\"cli.cakebox\",\"level\":100,\"ctxt_scope\":[]}"
    logArray[message]="\"$2\""
    logArray[tags]="[\"cli.cakebox\", \"$3\"]"
    logArray[type]='"cakephp"'

    printf '{'
    for lkey in "${!logArray[@]}"
    do
        printf '"@%s":%s,' "$lkey" "${logArray[$lkey]}"
    done
    echo '}'

}


function SCRIPTENTRY(){
 timestamp=$( date -u +"%Y-%m-%dT%H:%M:%S.%3N%:z" )
 script_name=`basename "$0"`
 script_name="${script_name%.*}"
 message="started $script_name"
 generate_log "$timestamp" "$message" 'debug' >> $SCRIPT_LOG
}

function SCRIPTEXIT(){
 script_name=`basename "$0"`
 script_name="${script_name%.*}"
 message="exited $script_name"
 generate_log "$timestamp" "$message" 'debug' >> $SCRIPT_LOG
}

function ENTRY(){
 local cfn="${FUNCNAME[1]}"
 timestamp=$( date -u +"%Y-%m-%dT%H:%M:%S.%3N%:z" )
 message="$cfn $FUNCNAME"
 generate_log "$timestamp" "$message" 'debug' >> $SCRIPT_LOG
}

function EXIT(){
 local cfn="${FUNCNAME[1]}"
 timestamp=$( date -u +"%Y-%m-%dT%H:%M:%S.%3N%:z" )
 message="$cfn $FUNCNAME"
 generate_log "$timestamp" "$message" 'debug' >> $SCRIPT_LOG
}


function INFO(){
 local function_name="${FUNCNAME[1]}"
    local message="$1"
    timestamp=$( date -u +"%Y-%m-%dT%H:%M:%S.%3N%:z" )
    generate_log "$timestamp" "$message" 'info' >> $SCRIPT_LOG
}


function DEBUG(){
 local function_name="${FUNCNAME[1]}"
    local message="$1"
    timestamp=$( date -u +"%Y-%m-%dT%H:%M:%S.%3N%:z" )
    generate_log "$timestamp" "$message" 'debug'  >> $SCRIPT_LOG
}

function ERROR(){
 local function_name="${FUNCNAME[1]}"
    local message="$1"
    timestamp=$( date -u +"%Y-%m-%dT%H:%M:%S.%3N%:z" )
    generate_log "$timestamp" "$message" 'error' >> $SCRIPT_LOG
}
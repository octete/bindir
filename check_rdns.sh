#!/bin/bash

# Check that a given host resolves to an IP and it resovles back to the same thing.
#

HOST=$1

if [[ -z "$HOST" ]] ; then
    echo "You need to specify a host" >&2
    exit 1
fi

export HOST

if  echo $HOST | grep -q -P "\d+\.\d+\.\d+\.\d"  ; then
    #echo "IP"
    rdns=$(getent hosts $HOST | awk '{print $2}')
    if [[ "$?" != "0" ]]  ; then
        echo "Could not find reverse DNS for host $HOST with IP $ip" >&2
        exit 1
    fi
    export rdns
    echo "Host $HOST resolves back to $rdns"
else
    #echo "Hostname. Forward DNS"
    ip=$(getent hosts $HOST | awk '{print $1}')
    if [[ "$?" != "0" ]]  ; then
        echo "Could not find forward DNS for host $HOST" >&2
        exit 1
    fi
    export ip
    rdns=$(getent hosts $ip | awk '{print $2}')
    if [[ "$?" != "0" ]]  ; then
        echo "Could not find reverse DNS for host $HOST with IP $ip" >&2
        exit 1
    fi
    export rdns
    echo "Host $HOST resolves to IP: $ip which resolves back to $rdns"
fi
    # it's not an IP Address




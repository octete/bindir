#!/bin/bash

# Get a file with a list of boxes, and ssh into them to get 
# their public IP addresses and check their rDNS to see if they
# match or not.

FILE=$1

if [[ -z "$FILE" ]] ; then
    echo "You have to specify a file to read from" >&2
    exit 1
fi

if [[ ! -e "$FILE" ]] ; then 
    echo "File $FILE doesn't seem to exist" >&2
    exit 2
fi

# Aux program to check the rdns
CHECK_RDNS="$HOME/bin/check_rdns.sh"

for SRV in $(cat $FILE) ; do 
    echo "$SRV:"
    ips=$(ssh -l root $SRV "ip address ls" | grep -o "inet [0-9\.]*" | grep -v -P "10\.\d+\.\d+\.\d+" | grep -v -P "192\.\d+\.\d+\.\d+" |  grep -v -P "127\.0\.0\.\d+" | cut -d " " -f 2 ) 
    for ip in $ips ; do 
        $CHECK_RDNS $ip 
    done    
    echo "-----------------------------------------" 
done


#!/bin/bash
rest=$*
if [[ -z $rest ]] ;then
  echo "You need to specify at least one server"
  exit 1
fi
command="multitail -s 2 "
for server in $rest
do
  command="$command -CS vmstat -t $server -l  \"ssh $server vmstat 1 \" "
done
eval $command

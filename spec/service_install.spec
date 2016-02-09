#!/bin/bash

if [[ ! -d /etc/init.d/consul ]]
then
  printf "The consul init script is missing, puppet will have to reinstall it"
  exit 0
fi

is_server=$(cat /usr/local/consul/conf/config.json | grep '"server":' | sed -e 's/.*": //' -e 's/, *$//')
if [[ "$is_server" = "true" ]]
then
  printf "Machine is a consul server; NOT restarting consul\n"
else
  printf "Machine is not a consul server; Restarting consul agent\n"
  /etc/init.d/consul restart
fi

exit 0

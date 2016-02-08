#!/bin/bash

PATH=/usr/bin:/bin:/sbin:/usr/sbin
# if this is a full remove (not an upgrade),
# remove the user and config files
if [[ $1 -eq 0 ]]; then
    userdel -r consul-template > /dev/null 2>&1
    rm -rf /var/local/consul-template/conf
fi

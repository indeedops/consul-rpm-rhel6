#!/bin/bash
PATH=/usr/bin:/bin:/sbin:/usr/sbin
chmod +x /usr/local/bin/consul-template
useradd -u 1937 -s /sbin/nologin -M consul-template &>/dev/null
mkdir -p /var/local/consul-template/conf
chown consul-template:consul-template /var/local/consul-template/conf

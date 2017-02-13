#!/bin/bash

scan_port=80
ipaddress_ary=(192.168.4.61 192.168.4.62)
vip=201.1.1.59

while [ 1 ] 
do
    for ip in ${ipaddress_ary[*]}
    do
    	web_stat=$(nc -z $ip $scan_port)
    	web_in_lvs=$(ipvsadm -Ln | grep $ip)
    	
    	if [ -n "$web_stat" -a -z "$web_in_lvs" ];then
    		ipvsadm -a -t $vip:$scan_port -r $ip
    	elif [ -z "$web_stat" -a -n "$web_in_lvs" ];then
    		ipvsadm -d -t $vip:$scan_port -r $ip
    	fi
    done
    sleep 1 
done

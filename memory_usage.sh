#!/bin/bash

: " 
 @file  : memory_usage.sh 
 @brief : this function check the memory of system and sends
          alert in case memory exceeds to a particular limit
 "

server_ip=`wget -qO- http://ipecho.net/plain ; echo`
subject="AWS Memory Usage Alert"
from="saurabhkv01@gmail.com"
recipients="saurabhkumar.verma@vvdntech.com"

ext_usage_limit=80
tmpfs_usage_limit=70
nfs_usage_limit=90

ext_flag=0
tmpfs_flag=0
nfs_flag=0
ext_usage=0
tmpfs_usage=0
nfs_usage=0

# Script functions
function ext_usage_check() {
        ext_usage=`df -ht ext3 | cut -d'%' -f1 | awk '{print $5}' | tail -n1`
        if [ $ext_usage -gt $ext_usage_limit ] ; then
                ext_flag=1
                usage_msg="Local Memory: "$ext_usage"%"
        fi  
}

function tmpfs_usage_check() {
        tmpfs_usage=`df -ht tmpfs | cut -d'%' -f1 | awk '{print $5}' | tail -n1`
        if [ $tmpfs_usage -gt $tmpfs_usage_limit ] ; then
                tmpfs_flag=1
        fi

        if [ $tmpfs_flag == 1 ] ; then
                if [ $ext_flag == 1 ] ; then
                       usage_msg="Local Memory: "$ext_usage"%\nTmpfs memory: "$tmpfs_usage"%"
                else
                        usage_msg="Tmpfs memory: "$tmpfs_usage"%"
                fi
        fi
}

function nfs_usage_check() {
        nfs_usage=`df -ht nfs | cut -d'%' -f1 | awk '{print $4}' | tail -n1`
        if [ $nfs_usage -gt $nfs_usage_limit ] ; then
                nfs_flag=1
        fi

        if [ $nfs_flag == 1 ] ; then
                if [ $ext_flag == 1 ] && [ $tmpfs_flag == 1 ] ; then
                        usage_msg="Local Memory: "$ext_usage"%\nTmpfs memory: "$tmpfs_usage"%\nNFS mounted memory: "$nfs_usage"%"
                elif [ $ext_flag == 1 ] ; then
                        usage_msg="Local Memory: "$ext_usage"%\nNFS mounted memory: "$nfs_usage"%"
                elif [ $tmpfs_flag == 1 ] ; then
                        usage_msg="Tmpfs memory exceed: "$tmpfs_usage"%\nNFS mounted memory: "$nfs_usage"%"
                else
                        usage_msg="NFS mounted memory: "$nfs_usage"%"
                fi
        fi
}

function main() {
        ext_usage_check
        tmpfs_usage_check
        nfs_usage_check

        echo -e "ext_flag:"$ext_flag"\ntmpfs_flag:"$tmpfs_flag"\nnfs_flag:"$nfs_flag

        if [ $ext_flag == 1 ] || [ $tmpfs_flag == 1 ] ||  [ $nfs_flag == 1 ] ; then
                mail="subject:$subject\nfrom:$from\nServer IP: $server_ip\nMemory Usage Details: \n$usage_msg"
                echo -e $mail | /usr/sbin/sendmail "$recipients"
        fi
}

main
~/sage-ccps/sync_manager/memory_usage.sh [FORMAT=unix] [TYPE=SH]                                                                                                                  81/81,1-1 Bot
                                                                                  

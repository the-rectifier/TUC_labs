#!/bin/bash
# You are NOT allowed to change the files' names!
domainNames="domainNames.txt"
IPAddresses="IPAddresses.txt"
adblockRules="adblockRules"


function add_rule(){
    sudo /usr/bin/iptables -A INPUT -w -s $ip -j REJECT
}

function resolve() {
    IPS=$(dig "$line" A +short)
    # echo $IPS
    for ip in $IPS 
    do
        if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
            # echo $ip >> $IPAddresses
            add_rule
        fi
    done
    
}

function adBlock() {
    if [ "$EUID" -ne 0 ];then
        printf "Please run as root.\n"
        printf "And FFS be careful"
        exit 1
    fi
    if [ "$1" = "-domains"  ]; then
        while IFS= read -r line
        do
            resolve&
        done < $domainNames
        wait
        true
            
    elif [ "$1" = "-ips"  ]; then
        while IFS= read -r ip
        do
            add_rule
        done < $IPAddresses
        true
        
    elif [ "$1" = "-save"  ]; then
        sudo /usr/bin/iptables-save --table filter > adblockRules
        true
        
    elif [ "$1" = "-load"  ]; then
        sudo /usr/bin/iptables-restore < adblockRules
        true

        
    elif [ "$1" = "-reset"  ]; then
        sudo iptables --table filter --flush INPUT                                                              
        true

        
    elif [ "$1" = "-list"  ]; then
        sudo /usr/bin/iptables --table filter -L -n 
        true
        
    elif [ "$1" = "-help"  ]; then
        printf "This script is responsible for creating a simple adblock mechanism. It rejects connections from specific domain names or IP addresses using iptables.\n\n"
        printf "Usage: $0  [OPTION]\n\n"
        printf "Options:\n\n"
        printf "  -domains\t  Configure adblock rules based on the domain names of '$domainNames' file.\n"
        printf "  -ips\t\t  Configure adblock rules based on the IP addresses of '$IPAddresses' file.\n"
        printf "  -save\t\t  Save rules to '$adblockRules' file.\n"
        printf "  -load\t\t  Load rules from '$adblockRules' file.\n"
        printf "  -list\t\t  List current rules.\n"
        printf "  -reset\t  Reset rules to default settings (i.e. accept all).\n"
        printf "  -help\t\t  Display this help and exit.\n"
        exit 0
    else
        printf "Wrong argument. Exiting...\n"
        exit 1
    fi
}

adBlock $1
exit 0
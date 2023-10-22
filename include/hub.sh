#!/bin/bash

# Check if user is root
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script!"
    exit 1
else
    if env |grep -q SUDO; then
        acme_sh_sudo="-f"
    fi
fi

echo "+------------------------------------------------------+"
echo "|    Manager for Sonic_Hub_Proxy, Written by Licess    |"
echo "+------------------------------------------------------+"

arg1=$1
arg2=$2
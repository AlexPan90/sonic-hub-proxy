#!/bin/bash

# Check if user is root
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script, please use root to start service."
    exit 1
fi

cur_dir=$(pwd)
Stack=$1
if [ "${Stack}" = "" ]; then
    Stack="lnmp"
else
    Stack=$1
fi

SONIC_HUB_Version='1.0'
. include/init.sh
. include/main.sh

clear
echo "+------------------------------------------------------+"
echo "|    Start the Sonic-Hub-Proxy service                 |"
echo "+------------------------------------------------------+"

Start()
{
    Check_Docker
    Start_SonicDatabase
    # Start_SonicServer
}

Start

#Install Docker
#Install MySQL
#Start Sonic-server & sonic-agent
#Insert Command 
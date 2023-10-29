#!/bin/bash

# Check if user is root
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script, please use root to start service."
    exit 1
fi

cur_dir=$(pwd)
Stack=$1
if [ "${Stack}" = "" ]; then
    Stack="sonic-hub-proxy"
else
    Stack=$1
fi

SONIC_HUB_Version='1.0'
. script/init.sh
. script/main.sh

clear
echo "+------------------------------------------------------+"
echo "|    Start the Sonic-Hub-Proxy service                 |"
echo "+------------------------------------------------------+"

Start()
{
    sonic_server_token="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOlsiYWRtaW4xMjMiLCI5NjNjMTQxYi1kN2IwLTQ3MGMtYjU5NS05NjgxY2Q3MGE1YzYiXSwiZXhwIjoxNjk5NzcyMTI0fQ.XArq_T_7zZj1Mntg9yIPVzvpScsMS0FaBfZPAS61wkY"
    # Install_Jq
    Check_Docker
    Start_SonicDatabase
    Start_SonicServer
    Config_SonicServer_Admin
    Start_SonicAgent
    
}

Start
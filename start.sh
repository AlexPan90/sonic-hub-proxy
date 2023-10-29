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
. script/hub.sh

clear
echo "+------------------------------------------------------+"
echo "|    Start the Sonic-Hub-Proxy service                 |"
echo "+------------------------------------------------------+"

Start()
{
    # Install_Jq
    Install_Yq
    Check_Docker
    Start_SonicDatabase
    Start_SonicServer
    Get_SonicServer_AccessToken
    Config_SonicServer_Admin
    Start_SonicAgent
    Start_SonicHubProxy
}

Start
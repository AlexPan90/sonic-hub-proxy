#!/bin/bash


Config_SonicHubProxy()
{   
    
    sonic_hub_yaml="$cur_dir/proxy.yml"

    endpoint_new_value="http://$sonic_server_host:3000%s"

    endpoint_value=$(yq '.services.sonic.endpoint' $sonic_hub_yaml)
    if [ $endpoint_value == "null" ];then
        $(yq -i '.services.sonic.endpoint = "'$endpoint_new_value'"' $sonic_hub_yaml)
    else
        $(yq -i '.services.sonic.endpoint = "'$endpoint_new_value'"' $sonic_hub_yaml)
    fi

    hub_request_token_value=$(yq '.services.sonic.hub_request_token' $sonic_hub_yaml)
    if [ $hub_request_token_value=="null" ];then
        $(yq -i '.services.sonic.hub_request_token = "'$sonic_server_token'"' $sonic_hub_yaml)
    else
        $(yq -i '.services.sonic.hub_request_token = "'$sonic_server_token'"' $sonic_hub_yaml)
    fi

    hub_dsn_new_value="root:sonic@tcp($sonic_server_host:3306)/sonic?charset=utf8&loc=Asia%2FShanghai"
    hub_dsn_value=$(yq '.services.sonic.hub_dsn' $sonic_hub_yaml)
    if [ $hub_dsn_value == "null" ];then
        $(yq -i '.services.sonic.hub_dsn = "'$hub_dsn_new_value'"' $sonic_hub_yaml)
    else
        $(yq -i '.services.sonic.hub_dsn = "'$hub_dsn_new_value'"' $sonic_hub_yaml)
    fi
}

module="sonic_hub_proxy"
log_hub_file="/var/log/sonic_hub.log"
pid_file="/var/run/$module.pid"
Start_SonicHubProxy()
{
    sonic_hub_bin="$cur_dir/bin/sonic_hub_proxy"

    echo $sonic_hub_bin

    if [ ! -f "$sonic_hub_bin" ];then
        Echo_Red "Error: No such '$sonic_hub_bin' directory, please check running path."
        exit 1
    fi

    Config_SonicHubProxy
    
    nohup $sonic_hub_bin >> $log_hub_file 2>&1 &
}
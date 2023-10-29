#!/bin/bash

Config_SonicDatabase()
{
    sonic_mysql_env="$cur_dir/sonic-database/.env"
    
    if [ -f $sonic_mysql_env ];then
        source $sonic_mysql_env
    else
        echo "Error: No such .env file."
        exit 1
    fi
    
    mysql_volume_config_dir=${cur_dir}/sonic-database/mysql/config
    mysql_volume_data_dir=${cur_dir}/sonic-database/mysql/data
    mysql_volume_logs_dir=${cur_dir}/sonic-database/mysql/logs

    sed -i "s#MYSQL_VOL_CONFIG=.*#MYSQL_VOL_CONFIG=${mysql_volume_config_dir}#" $sonic_mysql_env
    sed -i "s#MYSQL_VOL_DATA=.*#MYSQL_VOL_DATA=${mysql_volume_data_dir}#" $sonic_mysql_env
    sed -i "s#MYSQL_VOL_LOG=.*#MYSQL_VOL_LOG=${mysql_volume_logs_dir}#" $sonic_mysql_env
}

Is_Exist_SonicDatabase()
{
    exist_container_id=$(docker ps -a | grep $MYSQL_CONTAINER_NAME | awk '{print $1}')
}

Is_Runnig_SonicDatabase()
{
    running_container_id=$(docker ps | grep $MYSQL_CONTAINER_NAME | awk '{print $1}')
}

Start_SonicDatabase()
{
    sonic_database_dir="$cur_dir/sonic-database"

    Config_SonicDatabase

    Is_Exist_SonicDatabase
    if [ $exist_container_id ];then 
        restart_message=$(docker restart $exist_container_id)
        if [ $restart_message == $exist_container_id ];then
            Echo_Green "Database startup: "$exist_container_id
            return
        else
            docker logs $running_container_id
            Echo_Red "Error: Database startup failed."
            exit 1
        fi
    else
        cd $sonic_database_dir

        docker-compose -f docker-compose.yml up -d
        
        Is_Runnig_SonicDatabase
        if [ $running_container_id ];then
            Echo_Green "Database startup: "$running_container_id
            return
        else
            Is_Exist_SonicDatabase
            docker logs $exist_container_id
            Echo_Red "Error: Database startup failed."
            exit 1
        fi 
    fi
}

# Config_SonicServer
Config_SonicServer()
{
    LAN_Selection

    sonic_server_env="$cur_dir/sonic-server/.env"

    if [ -f $sonic_server_env ];then
        source $sonic_server_env
    else
        Echo_Red "Error: No such sonic server .env file."
        exit 1
    fi
    
    sed -i "s/SONIC_SERVER_HOST=.*/SONIC_SERVER_HOST=${sonic_server_host}/" $sonic_server_env
    sed -i "s/MYSQL_HOST=.*/MYSQL_HOST=${sonic_server_host}/" $sonic_server_env
    sed -i "s#LDAP_URL=.*#LDAP_URL=ldap://${sonic_server_host}:10389#" $sonic_server_env
}

# Start Sonic-server service by docker
Start_SonicServer()
{
    sonic_server_dir="$cur_dir/sonic-server"

    if [ ! -d "$sonic_server_dir" ];then
        Echo_Red "Error: No such '$sonic_server_dir' directory, please check running path."
        exit 1
    fi
   
    Config_SonicServer

    cd $sonic_server_dir

    docker-compose -f docker-compose-zh.yml up -d
}

Config_SonicServer_Admin()
{
    register_url="http://$sonic_server_host:3000/server/api/controller/users/register"
    
    data='{"userName":"admin", "password":"admin", "role": 2}'

    response=$(curl -s -X POST -H "Content-Type: application/json" -d "$data" "$register_url")

    http_status=$(curl -s -o /dev/null -w "%{http_code}" -X POST -H "Content-Type: application/json" -d "$data" "$register_url")

    if [ "$http_status" -eq 200 ];then
        if [[ "$response" == *"failed"* ]];then
            if [[ "$response" != *"User name already exists"* ]];then
                Echo_Red "Error: $response."
                exit 1
            fi
        fi
    else
        Echo_Red "Error: Sonic server may not be started."
        exit 1
    fi

    Echo_Green "[sonic-server] Please use the following account 'user=admin password=admin'"
}

Get_SonicServer_AccessToken()
{
    server_login_url="http://$sonic_server_host:3000/server/api/controller/users/login"
    
    data='{"userName":"admin","password":"admin"}'

    response=$(curl -s -X POST -H "Content-Type: application/json" -d "$data" "$server_login_url")

    if [[ "$response" == *'"code":2000'* ]];then
        sonic_server_token=$(echo $response | jq -r '.data')
        if [ -z $sonic_server_token ];then
            Echo_Red "Error: $response."
            exit 1
        else
            Echo_Green "[sonic-server] access_token: "$sonic_server_token
        fi
    elif [[ "$response" != *'"code":2000'* ]];then
        Echo_Red "Error: $response."
        exit 1
    else
        Echo_Red "Error: Sonic server may not be started."
        exit 1
    fi
}

Get_SonicAgent_SecretKey()
{
    agents_list_url="http://$sonic_server_host:3000/server/api/controller/agents/list"

    response=$(curl -s -X GET -H "Content-Type: application/json" -H "SonicToken: $sonic_server_token" "$agents_list_url")

    http_status=$(curl -s -o /dev/null -w "%{http_code}" -X GET -H "Content-Type: application/json" -H "SonicToken: $sonic_server_token" "$agents_list_url")

    if [ "$http_status" -eq 200 ];then
        agent_secret_key=$(echo "$response" | jq '.data[0].secretKey')
        if [ -z "$agent_secret_key" ] || [ "$agent_secret_key" == "null" ] ; then 
            Create_SonicAgent_SecretKey
        fi
    else
        Echo_Red "Error: Sonic server may not be started."
        exit 1
    fi

    agent_secret_key=$(echo $agent_secret_key | sed 's/\"//g')
}


# Configure agent key
Create_SonicAgent_SecretKey() 
{
    agents_update_url="http://$sonic_server_host:3000/server/api/controller/agents/update"
    
    data='{"id":0,"name":"hub02","highTemp":45,"highTempTime":15,"robotSecret":"","robotToken":"","robotType":-1,"alertRobotIds":null}'

    response=$(curl -s -X PUT -H "Content-Type: application/json" -H "SonicToken: $sonic_server_token" -d "$data" "$agents_update_url")

    if [[ "$response" == *'"code":2000'* ]];then
        Get_SonicAgent_SecretKey
    elif [[ "$response" != *'"code":2000'* ]];then
        Echo_Red "Error: $response."
        exit 1
    else
        Echo_Red "Error: Sonic server may not be started."
        exit 1
    fi
}

Config_SonicAgent()
{
    sonic_agent_env="$cur_dir/sonic-agent/.env"
    if [ -f $sonic_agent_env ];then
        source $sonic_agent_env
    else
        Echo_Red "Error: No such sonic agent .env file."
        exit 1
    fi

    Get_SonicAgent_SecretKey

    Echo_Green "[sonic-agent] secret key: "$agent_secret_key

    sed -i "s/SONIC_SERVER_HOST=.*/SONIC_SERVER_HOST=${sonic_server_host}/" $sonic_agent_env
   
    # TODO:
    # sed -i "s/MYSQL_HOST=.*/SONIC_SERVER_PORT=3000/" $sonic_server_env
    sed -i "s/SONIC_AGENT_KEY=.*/SONIC_AGENT_KEY=${agent_secret_key}/" $sonic_agent_env
    sed -i "s/SONIC_AGENT_HOST=.*/SONIC_AGENT_HOST=${sonic_server_host}/" $sonic_agent_env
}

Start_SonicAgent()
{
    sonic_agent_dir="$cur_dir/sonic-agent"

    if [ ! -d "$sonic_agent_dir" ];then
        Echo_Red "Error: No such '$sonic_agent_dir' directory, please check running path."
        exit 1
    fi

    Config_SonicAgent

    cd $sonic_agent_dir

    docker-compose -f docker-compose-zh.yml up -d
}
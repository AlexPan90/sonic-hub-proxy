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

Start_SonicDatabase()
{
    sonic_database_dir="$cur_dir/sonic-database"

    Config_SonicDatabase

    cd $sonic_database_dir

    docker-compose -f docker-compose.yml up -d
}


Config_SonicServer()
{
    LAN_Selection

    sonic_server_env="$cur_dir/sonic-server/.env"

    if [ -f $sonic_server_env ];then
        source $sonic_server_env
    else
        echo "Error: No such .env file."
    exit 1
    fi
    
    sed -i "s/SONIC_SERVER_HOST=.*/SONIC_SERVER_HOST=${sonic_server_host}/" $sonic_server_env
}

# Start Sonic-server service by docker
Start_SonicServer()
{
    sonic_server_dir="$cur_dir/sonic-server"

    if [ ! -d "$sonic_server_dir" ];then
        Echo_Red "Error: No such '$sonic_server_dir' directory, please check running path."
        exit 1
    fi
    docker-compose -f docker-compose-zh.yml up -d
    Config_SonicServer

    cd $sonic_server_dir

    
}

Start_SonicAgent()
{
    echo 1
}
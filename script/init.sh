#!/usr/bin/env bash

Set_Timezone()
{
    Echo_Blue "Setting timezone..."
    rm -rf /etc/localtime
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
}

# Select Native LAN
LAN_Selection()
{   
    # physical_network_cards=$(ls /sys/class/net/ | grep -v "`ls /sys/devices/virtual/net`")
    # local_ip=$(ip addr | grep $physical_network_cards | grep -E "inet [0-9]" | awk '{print $2}' | awk -F"/" '{print $1}'));
    for ip in $(ip addr | grep "$(ls /sys/class/net/ | grep -v "`ls /sys/devices/virtual/net`")" | grep -E "inet [0-9]" | awk '{print $2}' | awk -F"/" '{print $1}'):
    do  
        # local_physical_net=$ip
        local_physical_net[${#local_physical_net[@]}]=${ip}
    done

    if [ -z ${local_physical_net} ];then
        echo "Error: No local network card information was detected."
        exit 1
    fi

    local_physical_net[${#local_physical_net[@]}]="127.0.0.1"

    if [ -z ${LocalIPSelect} ]; then
        LocalIPSelect="0"
        Echo_Yellow "You have [${#local_physical_net[@]}] network cards, please select one of them to start the server."
        number=0
        for i in ${!local_physical_net[@]};do
            if [ $i -eq 0 ];then
                echo "$i: Select ${local_physical_net[i]} (Default)"
            else
                echo "$i: Select ${local_physical_net[i]}"
            fi
        done
        read -p "Enter your choice number: " LocalIPSelect
    fi

    if [[ ${local_physical_net[LocalIPSelect]} == *":"* ]];then
        sonic_server_host=${local_physical_net[LocalIPSelect]//:/}
    fi
}


Check_Docker()
{
    if docker --version &> /dev/null; then
        docker_version=$(docker --version | awk '{print $3}')
        Echo_Green "Docker: OK, version: "$docker_version;
    fi

    pid=$(ps aux | grep "docker" | grep -v grep | awk '{print $2}')
    if [ -n "$pid" ];then
        if sudo docker info > /dev/null 2>&1;then
            Echo_Green "Docker($pid) is running."
        fi
    fi

    if docker-compose --version &> /dev/null;then
        docker_compose_version=$(docker-compose --version | awk '{print $3}')
        Echo_Green "Docker-compose: OK, version: "$docker_compose_version
    fi
}

Install_Yq()
{   
    yq_version=$(yq --version | grep 'version') 

    if [ -z "$yq_version" ];then
        echo "====== Installing Yq ======"
        Press_Start
        Echo_Blue "[+] Installing Yq"
        wget https://github.com/mikefarah/yq/releases/download/v4.20.2/yq_linux_amd64 \
        && chmod +x yq_linux_amd64 \
        && mv yq_linux_amd64 /usr/local/bin/yq
    fi

    Echo_Green "Installed "$yq_version
}

Install_Jq()
{
    echo "====== Installing jq ======"
    Press_Start
    Echo_Blue "[+] Installing Jq"
    $(apt-get install jq)
}

Install_Curl()
{
    if [[ ! -s /usr/local/curl/bin/curl || ! -s /usr/local/curl/lib/libcurl.so || ! -s /usr/local/curl/include/curl/curl.h ]]; then
        Echo_Blue "[+] Installing ${Curl_Ver}"
        cd ${cur_dir}/src
        Download_Files ${Download_Mirror}/lib/curl/${Curl_Ver}.tar.bz2 ${Curl_Ver}.tar.bz2
        Tar_Cd ${Curl_Ver}.tar.bz2 ${Curl_Ver}
        if [ -s /usr/local/openssl/bin/openssl ] || /usr/local/openssl/bin/openssl version | grep -Eqi 'OpenSSL 1.0.2'; then
            ./configure --prefix=/usr/local/curl --enable-ares --without-nss --with-zlib --with-ssl=/usr/local/openssl
        else
            ./configure --prefix=/usr/local/curl --enable-ares --without-nss --with-zlib --with-ssl
        fi
        Make_Install
        cd ${cur_dir}/src/
        rm -rf ${cur_dir}/src/${Curl_Ver}
        ldconfig
    fi
    Remove_Error_Libcurl
}

Press_Start()
{
    echo ""
    Echo_Green "Press any key to start...or Press Ctrl+c to cancel"
    OLDCONFIG=`stty -g`
    stty -icanon -echo min 1 time 0
    dd count=1 2>/dev/null
    stty ${OLDCONFIG}
}


Color_Text()
{
  echo -e " \e[0;$2m$1\e[0m"
}

Echo_Red()
{
  echo $(Color_Text "$1" "31")
}

Echo_Green()
{
  echo $(Color_Text "$1" "32")
}

Echo_Yellow()
{
  echo $(Color_Text "$1" "33")
}

Echo_Blue()
{
  echo $(Color_Text "$1" "34")
}
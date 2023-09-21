#!/bin/bash

# 定义变量
    File_name=unidbg-fetch-qsign-1.2.1.zip
    directory=unidbg-fetch-qsign-1.2.1
    link=https://github.com/fuqiuluo/unidbg-fetch-qsign/releases/download/1.2.1/unidbg-fetch-qsign-1.2.1.zip


        if [ ! -d /sign ];then
            mkdir /sign
        fi
        # 是否安装了 QSign
        if [ -d /sign/unidbg-fetch-qsign ];then
            clear
            echo -e "\e[1;33m您已安装过 QSign 了 \e[0m"
            echo -e "\e[34m请勿重复安装\e[0m"
            exit 0
            fi
            
            # 安装环境
            echo -e "\e[35m正在检查 QSign 所需的环境\e[0m"
            sleep 2
            # 检查并安装wget
        if ! command -v wget >/dev/null 2>&1; then
        clear
        echo -e "\e[1;35m正在安装wget...\e[0m"
        apt update
        apt install -y wget
        fi
        
        if ! command -v numfmt >/dev/null 2>&1; then
        clear
        apt update
        apt install -y numfmt
        fi

    # 检查并安装jdk
    if ! command -v java >/dev/null 2>&1; then
    clear
    echo -e "\e[1;35m正在安装jdk...\e[0m"
    apt update
    apt install -y default-jdk
    fi

    # 检查并安装unzip
    if ! command -v unzip >/dev/null 2>&1; then
    echo -e "\e[1;35m正在安装unzip...\e[0m"
    apt update
    apt install -y unzip
    fi

    if ! [ -x "$(command -v curl)" ];then
    echo -e "\033[36m- 检测到未安装curl 开始安装 \033[0m";
   apt update
   apt install curl -y
    fi

    # 检查并安装Node.js
    if ! command -v node &> /dev/null
        then
        echo "- Node.js 未安装"
        Ubuntuv=$(lsb_release -r | awk '{print $2}')
        until npm -v
        do
        if [ "$Ubuntuv" == "18.04" ]; then
          rm /etc/apt/sources.list.d/nodesource.list
          bash <(curl -sL https://deb.nodesource.com/setup_16.x)
        elif [ "$Ubuntuv" == "22.04" ]; then
          rm /etc/apt/sources.list.d/nodesource.list
          bash <(curl -sL https://deb.nodesource.com/setup_18.x)
        elif [ "$Ubuntuv" == "22.10" ]; then
          rm /etc/apt/sources.list.d/nodesource.list
          bash <(curl -sL https://deb.nodesource.com/setup_18.x)
        else
          rm /etc/apt/sources.list.d/nodesource.list
          bash <(curl -sL https://deb.nodesource.com/setup_16.x)
        fi
        apt remove nodejs -y
        apt autoremove -y
        apt update -y
        apt install -y nodejs
        done
    fi

    # 检查并安装pm2
    if ! command -v pm2 >/dev/null 2>&1; then
    echo  -e "\e[1;35m正在安装PM2...\e[0m"
    npm install -g pm2
    fi
       # 下载     
        cd /sign
        clear
            # 使用 github 代理加速下载1.1.6版本压缩包
            echo -e "正在从\e[0m \e[1;35mGHProxy\e[0m 上下载\e[35m QSign \e[0m"
            rm -rf $File_name
            wget https://ghproxy.com/$link
        # 如果文件不存在
        if [ ! -e $File_name ];then
           echo -e "\e[1;31mQSign下载失败！请加群692314526反馈\e[0m"
           echo -e "\e[1;33m请务必附带截图！\n请务必附带截图！\n请务必附带截图！\n\e[0m重要的事说三遍..."
            exit 1
        else
            cd /sign
            clear
            echo -e "\e[34m正在解压文件...\e[0m"
            rm -rf $directory
            unzip $File_name
            mv $directory unidbg-fetch-qsign
            rm -rf $File_name
            
            if [ -d unidbg-fetch-qsign ];then
            echo -e '\e[32m QSign 安装完成，您可以使用启动签名服务器"启动签名服务器"选项进行启动！\e[0m'
            echo "==============API地址============="
            echo "    签名API地址均为:127.0.0.1:8080"
            echo "  如果出现端口占用请先关闭其他版本的签名"
            echo "================================="
            echo "       Key 均为默认的 114514 "
            echo "================================="
  echo -e "\e[33m 此信息仅显示一次，请截图保存或妥善牢记\e[0m"
        # 无用的东西
        file_size=$(stat -c%s "$File_name")
        formatted_size=$(numfmt --to=iec-i --suffix=B --format="%.2f" $file_size)
        rm -rf $File_name
        echo "已为您自动删除安装包！释放了$formatted_size"
        exit 0
    else
        echo -e "\e[1;31m 安装错误！请回报错误并重试！\e[0m"
            rm -rf $File_name
            rm -rf $directory
            rm -rf unidbg-fetch-qsign
            exit 1
    fi
fi
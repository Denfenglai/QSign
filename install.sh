#!/bin/bash

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
            echo -e "\e[35m正在安装 QSign 所需的环境\e[0m"
            sleep 2
            # 检查并安装wget
        if ! command -v wget >/dev/null 2>&1; then
        clear
        echo -e "\e[1;35m正在安装wget...\e[0m"
        apt update
        apt install -y wget
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
    if ! command -v node >/dev/null 2>&1; then
    clear
    echo -e "\e[1;35m正在安装Node.js...\e[0m"
    curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
    apt update
    apt install -y nodejs npm
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
            rm -rf unidbg-fetch-qsign-1.1.6.zip
            wget https://ghproxy.com/https://github.com/fuqiuluo/unidbg-fetch-qsign/releases/download/1.1.6/unidbg-fetch-qsign-1.1.6.zip
        # 如果文件不存在
        if [ ! -e unidbg-fetch-qsign-1.1.6.zip ];then
           echo -e "\e[1;31mQSign下载失败！请加群692314526反馈\e[0m"
           echo -e "\e[1;33m请务必附带截图！\n请务必附带截图！\n请务必附带截图！\n\e[0m重要的事说三遍..."
            exit 1
        else
            cd /sign
            clear
            echo -e "\e[34m正在解压文件...\e[0m"
            rm -rf unidbg-fetch-qsign-1.1.6
            unzip unidbg-fetch-qsign-1.1.6.zip
            mv unidbg-fetch-qsign-1.1.6 unidbg-fetch-qsign
            
        if [ -d unidbg-fetch-qsign ];then
            # 写入配置文件
# 8963
echo "{
  "server": {
    "host": "127.0.0.1",
    "port": 8963
  },
  "key": "114514",
  "auto_register": true,
  "protocol": {
    "qua": "V1_AND_SQ_8.9.63_4194_YYB_D",
    "version": "8.9.63",
    "code": "4194"
  },
  "unidbg": {
    "dynarmic": false,
    "unicorn": true,
    "debug": false
  }
}" > /sign/unidbg-fetch-qsign/txlib/8.9.63/txlib/config.json

# 8968
echo "{
  "server": {
    "host": "127.0.0.1",
    "port": 8968
  },
  "key": "114514",
  "auto_register": true,
  "protocol": {
    "qua": "V1_AND_SQ_8.9.68_4264_YYB_D",
    "version": "8.9.68",
    "code": "4264"
  },
  "unidbg": {
    "dynarmic": false,
    "unicorn": true,
    "debug": true
  },
  "black_list": [
    1008611
  ]
}" > /sign/unidbg-fetch-qsign/txlib/8.9.68/config.json

# 8970
echo "{
  "server": {
    "host": "127.0.0.1",
    "port": 8970
  },
  "key": "114514",
  "auto_register": true,
  "protocol": {
    "qua": "V1_AND_SQ_8.9.70_4292_HDBM_T",
    "version": "8.9.70",
    "code": "4292"
  },
  "unidbg": {
    "dynarmic": false,
    "unicorn": true,
    "debug": false
  }
}" > /sign/unidbg-fetch-qsign/txlib/8.9.70/config.json


            echo -e "\e[1;32m QSign 安装完成！\e[0m是否立即启动？(Y/n)"
            read -r response
        if [[ $response =~ ^[Yy]$ ]] || [[ -z $response ]]; then
            cd /sign/unidbg-fetch-qsign
            bash bin/unidbg-fetch-qsign --basePath=txlib/8.9.68
        else 
            echo -e '\e[32m安装完成，您可以使用启动签名服务器"启动签名服务器"选项进行启动！\e[0m'
            echo "==============API地址============="
            echo "  8.9.63： http://127.0.0.1:8963"
            echo "  8.9.68:  http://127.0.0.1:8968"
            echo "  8.9.70:  http://127.0.0.1:8970"
            echo "================================="
            echo "       Key 均为默认的 114514 "
            echo "================================="
  echo -e "\e[33m 此信息仅显示一次，请截图保存或妥善牢记\e[0m"
            exit 0
        fi
                rm -rf unidbg-fetch-qsign-1.1.6.zip
        else
            echo -e "\e[1;31m 安装错误！请回报错误并重试！\e[0m"
                rm -rf unidbg-fetch-qsign-1.1.6.zip
                rm -rf unidbg-fetch-qsign-1.1.6
                rm -rf unidbg-fetch-qsign
                exit 1
    fi
fi
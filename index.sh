#!/bin/bash

if ! [ "$(uname)" == "Linux" ];then
echo -e "\033[31m 请使用linux! \033[0m"
exit 0
fi

if ! [ -f /etc/lsb-release ];then
echo -e "\033[31m 请使用ubuntu! \033[0m"
exit 0
fi

if [ "$(id -u)" != "0" ]; then
echo -e "\033[31m 请使用root用户! \033[0m"
exit 0
fi

# 检查并安装whiptail
if ! command -v whiptail >/dev/null 2>&1; then
  echo "正在安装whiptail..."
  apt update
  apt install -y whiptail
fi

export NEWT_COLORS='
root=,yellow
'
sign=$(whiptail \
--title "签名服务器管理" \
17 40 9 \
"1" "安装签名服务器" \
"2" "启动签名服务器" \
"3" "停止签名服务器" \
"4" "查看日志" \
"5" "修改key" \
"6" "修改端口" \
"7" "前台启动"  \
"8" "卸载相关内容" \
3>&1 1>&2 2>&3)
feedback=$?
if [ $feedback = 0 ];then
    case $sign in
    "1")
        # 新目录
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
        echo "正在安装wget..."
        apt update
        apt install -y wget
        fi

    # 检查并安装jdk
    if ! command -v java >/dev/null 2>&1; then
    echo "正在安装jdk..."
    clear
    apt update
    apt install -y default-jdk
    fi

    # 检查并安装unzip
    if ! command -v unzip >/dev/null 2>&1; then
    echo "正在安装unzip..."
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
    echo "正在安装Node.js..."
    curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
    apt update
    apt install -y nodejs npm
    fi

    # 检查并安装pm2
    if ! command -v pm2 >/dev/null 2>&1; then
    echo "正在安装PM2..."
    npm install -g pm2
    fi
       # 下载     
        cd /sign
        clear
            # 使用 github 代理加速下载1.1.6版本压缩包
            echo -e "\e[35m正在从\e[0m GHProxy 上下载\e[35m QSign \e[0m"
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
            unzip unidbg-fetch-qsign-1.1.6.zip
            mv unidbg-fetch-qsign-1.1.6 unidbg-fetch-qsign
        if [ -d unidbg-fetch-qsign ];then
            echo -e "\e[1;32m QSign 安装完成！\e[0m是否立即启动？(Y/n)"
            read -r response
        if [[ $response =~ ^[Yy]$ ]] || [[ -z $response ]]; then
            cd /sign/unidbg-fetch-qsign
            bash bin/unidbg-fetch-qsign --basePath=txlib/8.9.68
        else 
            echo -e '\e[32m安装完成，您可以使用启动签名服务器"启动签名服务器"选项进行启动！'
            exit 0
        fi
    fi
fi
        ;;
    
    "2")
    if [ -d /sign/unidbg-fetch-qsign ];then
        start=$(whiptail \
        --title "启动QSign" \
        --menu "请选择你要启动的版本" \
        15 35 5 \
        "1" "8.9.63" \
        "2" "8.9.68" \
        "3" "8.9.70[推荐]" \
        3>&1 1>&2 2>&3 )
    if [ $start = 1 ];then
        version=8.9.63
        cd /sign/unidbg-fetch-qsign
        pm2 start --name $version "bash bin/unidbg-fetch-qsign --basePath=txlib/$version"
    fi
        
    if [ $start = 2 ];then
        version=8.9.68
        cd /sign/unidbg-fetch-qsign
        pm2 start --name $version "bash bin/unidbg-fetch-qsign --basePath=txlib/$version"
    fi
        
    if [ $start = 3 ];then
        version=8.9.70
        cd /sign/unidbg-fetch-qsign
        pm2 start --name $version "bash bin/unidbg-fetch-qsign --basePath=txlib/$version"
    fi
    
    fi
    
    "3")
        clear
        pm2 ls
        echo -e "\e[34m请输入你要关闭的进程名称（如：8.9.68）\e[0m"
        read -r pid
        if [ $pid = 8.9.63 || $pid = 8.9.68 || $pid = 8.9.70 ];then
            pm2 stop $pid
        else
            echo -e "\e[31m请输入正确的进程名称！\e[0m"
        fi
        ;;
    *)
        echo "还在咕咕中...通宵没睡要猝死啦~"
        exit
        ;;
    esac
    
else
  exit 0
fi

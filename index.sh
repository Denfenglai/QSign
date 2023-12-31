#!/bin/bash

# 写入快捷键
echo '
Yz=$(head -n 1 "${HOME}/.Yunzai")
case $1 in

    -i)
sed -i "/sign_api_addr/d" $Yz/config/config/bot.yaml
sed -i "\$a\sign_api_addr: $2" $Yz/config/config/bot.yaml
API=$(grep sign_api_addr $Yz/config/config/bot.yaml)
API=$(echo ${API} | sed "s/sign_api_addr//g")
echo -e "\e[34m您的API链接已修改为 \e[32m${API}\e[0m"
exit
    ;;

    *)      
      bash <(curl -sL gitee.com/Wind-is-so-strong/sign/raw/master/index.sh)
    ;;
esac
' > /usr/bin/sign
chmod 777 /usr/bin/sign

# 检查用户
check_requirements() {
  if ! [ "$(uname)" == "Linux" ]; then
    echo -e "\033[31m请使用Linux！\033[0m"
    exit 0
  fi

  if ! [ -f /etc/lsb-release ]; then
    echo -e "\033[31m请使用Ubuntu！\033[0m"
    exit 0
  fi

  if [ "$(id -u)" != "0" ]; then
    echo -e "\033[31m请使用root用户！\033[0m"
    exit 0
  fi
}
# 安装whiptail
install_whiptail() {
  if ! command -v whiptail >/dev/null 2>&1; then
    echo "正在安装whiptail..."
    apt-get -qq update
    apt-get install -y whiptail
  fi
}
# 启动
start_qsign() {
  local version
  local base_path

  case $1 in
    1)
      version="8.9.63"
      base_path="txlib/$version"
      ;;
    2)
      version="8.9.68"
      base_path="txlib/$version"
      ;;
    3)
      version="8.9.71"
      base_path="txlib/$version"
      ;;
    4)
      version="8.9.73"
      base_path="txlib/$version"
      ;;
    5)
      version="3.5.1"
      base_path="txlib/$version"
      ;;
    6)
      version="3.5.2"
      base_path="txlib/$version"
      ;;
    *)
      echo -e "\e[31m无效的版本选择！\e[0m"
      return
  esac

  if [ -d /sign/unidbg-fetch-qsign ]; then
    cd /sign/unidbg-fetch-qsign
    clear
    pm2 start --name $version "bash bin/unidbg-fetch-qsign --basePath=$base_path"
    echo -e "\e[1;32m $version 已启动\e[0m"
  else 
   echo -e "\e[1;31m请先安装签名服务器\e[0m"
     exit 1
fi
}

# 前台启动
fo_qsign() {
  local version
  local base_path

  case $1 in
    1)
      version="8.9.63"
      base_path="txlib/$version"
      ;;
    2)
      version="8.9.68"
      base_path="txlib/$version"
      ;;
    3)
      version="8.9.71"
      base_path="txlib/$version"
      ;;
    4)
      version="8.9.73"
      base_path="txlib/$version"
      ;;
    5)
      version="3.5.1"
      base_path="txlib/$version"
      ;;
    6)
      version="3.5.2"
      base_path="txlib/$version"
      ;;
    *)
      echo -e "\e[31m无效的版本选择！\e[0m"
      return
  esac

  if [ -d /sign/unidbg-fetch-qsign ]; then
    cd /sign/unidbg-fetch-qsign
    clear
    bash bin/unidbg-fetch-qsign --basePath=$base_path
  else 
   echo -e "\e[1;31m请先安装签名服务器\e[0m"
     exit 1
fi
}
# 查看日志
logs_qsign() {
  local version

  case $1 in
    1)
      version="8.9.63"
      ;;
    2)
      version="8.9.68"
      ;;
    3)
      version="8.9.71"
      ;;
    4)
      version="8.9.73"
      ;;
    5)
      version="3.5.1"
      ;;
    6)
      version="3.5.2"
      ;;
    *)
      echo -e "\e[31m无效的版本选择！\e[0m"
      return
  esac

  if [ -d /sign/unidbg-fetch-qsign ]; then
    cd /sign/unidbg-fetch-qsign
    clear
    pm2 logs $version
    echo -e "\e[1;32m $version 已启动\e[0m"
    else
     echo -e "\e[1;31m请先安装签名服务器\e[0m"
     exit 1
fi
}


# 停止运行
stop_qsign() {
  clear
  pm2 ls
  echo -e "\e[34m请输入要关闭的进程名称（如：8.9.68）：\e[0m"
  read -r pid

  case $pid in
    8.9.63 | 8.9.68 | 8.9.71 | 8.9.73 | 3.5.1 | 3.5.2)
      clear
      pm2 stop $pid
    echo -e "\e[1;34m $pid 已停止运行\e[0m"
      exit 0
      ;;
    *)
      echo -e "\e[31m请输入正确的进程名称！\e[0m"
      ;;
  esac
}

check_requirements
install_whiptail

while true; do

  menu=$(whiptail \
    --title "签名服务器管理" \
    --menu "咕咕中" \
    17 40 10 \
    "1" "安装签名服务器" \
    "2" "启动签名服务器" \
    "3" "停止签名服务器" \
    "4" "查看日志" \
    "5" "修改key" \
    "6" "修改端口" \
    "7" "前台启动"  \
    "8" "卸载相关内容" \
    "9" "查看默认配置信息" \
    3>&1 1>&2 2>&3)

  feedback=$?

  if [ $feedback = 0 ]; then
    case $menu in
      1)
        bash <(curl -sL gitee.com/DengFengLai-F/sign/raw/master/install.sh)
        break
        ;;
      2)
        start=$(whiptail \
          --title "启动QSign" \
          --menu "请选择要启动的版本：" \
          15 35 7 \
          "1" "8.9.63" \
          "2" "8.9.68" \
          "3" "8.9.71" \
          "4" "8.9.73" \
          "5" "[Tim]3.5.1" \
          "6" "[Tim]3.5.2" \
          3>&1 1>&2 2>&3)
        start_qsign $start
        break
        ;;
      3)
        stop_qsign
        ;;
      4)
        logs=$(whiptail \
        --title "查看日志" \
        --menu "请选择要查看的日志版本 没显示则代表没有启动" \
        15 35 7 \
          "1" "8.9.63" \
          "2" "8.9.68" \
          "3" "8.9.71" \
          "4" "8.9.73" \
          "5" "[Tim]3.5.1" \
          "6" "[Tim]3.5.2" \
          3>&1 1>&2 2>&3)
        logs_qsign $logs
        break
        ;;

      5)
        clear
    if [ -d /sign/unidbg-fetch-qsign ];then
        echo -e "\e[1;33m请输入你要修改的key\e[0m"
        echo -n "Key："; read -r new_key
        # 循环
        a=("8.9.63" "8.9.68" "8.9.71" "8.9.73" "3.5.1" "3.5.2")
        for i in "${a[@]}"; do
        sed -i "s/\"key\": \"[0-9]*\",/\"key\": \"$new_key\",/" /sign/unidbg-fetch-qsign/txlib/$i/config.json
        done
        
      echo -en "你的Key已修改为$new_key 回车返回"; read -r
    else
        echo -e "\e[31m请先安装签名服务器\e[0m"
        exit 1
    fi
            
        ;;
      6)
        clear
        if [ -d /sign/unidbg-fetch-qsign ]; then
    echo -e "\e[1;33m请输入你要修改的端口号[1024-65535]: \e[0m"
    read -p "port: " port

    if [ "$port" -ge 1024 ] && [ "$port" -le 65535 ]; then
        # 使用 sed 命令替换文件中的端口号
        a=("8.9.63" "8.9.68" "8.9.71" "8.9.73" "3.5.1" "3.5.2")
        # 循环遍历
        for i in "${a[@]}"; do
        sed -i "s/\"port\": [0-9]*/\"port\": $port/" /sign/unidbg-fetch-qsign/txlib/$i/config.json
        done
        

        echo -e "\e[1;32m端口号已成功修改为 $port \e[0m"
        echo "服务器外网访问须在防火墙或安全组开放对应端口"
        echo -en "回车继续"; read -r
    else
        echo -e "\e[1;31m输入的端口号不在合理范围内\e[0m"
        exit 1
    fi
else
    echo -e "\e[31m请先安装签名服务器\e[0m"
    exit 1
fi
        ;;
      7)
        fo_start=$(whiptail \
          --title "启动QSign" \
          --menu "请选择要启动的版本：" \
          15 35 7 \
          "1" "8.9.63" \
          "2" "8.9.68" \
          "3" "8.9.71" \
          "4" "8.9.73" \
          "5" "[Tim]3.5.1" \
          "6" "[Tim]3.5.2" \
          3>&1 1>&2 2>&3)
        fo_qsign $fo_start
        break
        ;;
      8)
        if [ -d /sign ];then
        echo -e "\e[33m确定要删除签名服务器吗？此操作是不可逆的(Y/n)\e[0m"
        read -r response
    if [[ $response =~ ^[Yy]$ ]] || [[ -z $response ]]; then
        rm -rf /sign
        echo -e "\e[32mQSign签名服务器已彻底删除\e[0m"
        sleep 5
        else
            exit 0
            fi
        else
            echo -e "\e[35m笨比！你都没装我怎么删？你这个大笨蛋！\e[0m"
            sleep 4
            fi
        ;;
      9)
        echo 默认信息 不做修改则永远相同
            echo "==============API地址============="
            echo "    签名API地址均为:127.0.0.1:8080"
            echo "  如果出现端口占用请先关闭其他版本的签名"
            echo "================================="
            echo "       Key 均为默认的 114514 "
            echo "================================="
        echo
        echo -n "回车返回";read -p ""
        ;;
    esac
  else
    exit
  fi
done
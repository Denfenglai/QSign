#!/bin/bash

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

install_whiptail() {
  if ! command -v whiptail >/dev/null 2>&1; then
    echo "正在安装whiptail..."
    apt-get -qq update
    apt-get install -y whiptail
  fi
}

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
      version="8.9.70"
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
fi
}

stop_qsign() {
  clear
  pm2 ls
  echo -e "\e[34m请输入要关闭的进程名称（如：8.9.68）：\e[0m"
  read -r pid

  case $pid in
    8.9.63 | 8.9.68 | 8.9.70)
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
    --menu "QSign" \
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

  if [ $feedback = 0 ]; then
    case $menu in
      1)
        bash <(curl -sL gitee.com/Wind-is-so-strong/sign/raw/master/install.sh)
        break
        ;;
      2)
        start=$(whiptail \
          --title "启动QSign" \
          --menu "请选择要启动的版本：" \
          15 35 5 \
          "1" "8.9.63" \
          "2" "8.9.68" \
          "3" "8.9.70[推荐]" \
          3>&1 1>&2 2>&3)
        start_qsign $start
        ;;
      3)
        stop_qsign
        ;;
      4)
        # 查看日志的操作
        ;;
      5)
        # 修改key的操作
        ;;
      6)
        # 修改端口的操作
        ;;
      7)
        # 前台启动的操作
        ;;
      8)
        # 卸载相关内容的操作
        ;;
    esac
  else
    exit
  fi
done
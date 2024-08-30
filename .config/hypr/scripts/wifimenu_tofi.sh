#!/bin/bash

# 函数：使用tofi显示消息
show_message() {
    echo "$1" | tofi --prompt="$2" --height=100 --width=300
}

# 函数：连接到指定的WiFi
connect_to_wifi() {
    local ssid="$1"
    local password="$2"
    
    connection_result=$(nmcli device wifi connect "$ssid" password "$password" 2>&1)
    
    if [[ $connection_result == *"successfully activated"* ]]; then
        show_message "成功连接到 $ssid" "成功"
    else
        show_message "连接失败：$connection_result" "错误"
    fi
}

# 主菜单
choice=$(echo -e "1. 扫描并选择WiFi\n2. 手动输入WiFi信息" | tofi --prompt="选择操作：" --height=200)

case $choice in
    "1. 扫描并选择WiFi")
        # 扫描可用的WiFi网络
        networks=$(nmcli -t -f SSID device wifi list | sort | uniq)

        # 使用tofi让用户选择网络
        selected_network=$(echo "$networks" | tofi --prompt="选择WiFi网络：" --height=400)

        if [ -z "$selected_network" ]; then
            show_message "未选择网络，退出。" "错误"
            exit 1
        fi

        # 询问密码
        password=$(echo "" | tofi --prompt="输入 $selected_network 的密码：" --input-type=password --height=100)

        # 连接到网络
        connect_to_wifi "$selected_network" "$password"
        ;;
    
    "2. 手动输入WiFi信息")
        # 手动输入SSID
        ssid=$(echo "" | tofi --prompt="输入WiFi名称（SSID）：" --height=100)

        if [ -z "$ssid" ]; then
            show_message "未输入WiFi名称，退出。" "错误"
            exit 1
        fi

        # 手动输入密码
        password=$(echo "" | tofi --prompt="输入 $ssid 的密码：" --input-type=password --height=100)

        # 连接到网络
        connect_to_wifi "$ssid" "$password"
        ;;
    
    *)
        show_message "无效选择，退出。" "错误"
        exit 1
        ;;
esac


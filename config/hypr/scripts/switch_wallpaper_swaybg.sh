#!/bin/bash

# 壁纸存放的目录
wallpaper_dir="$HOME/.config/hypr/wallpaper"
#echo "wallpaper_dir : $wallpaper_dir"
# 显示器名称可通过'hyprctl monitors'查询
monitor_name="eDP-1"

wallpaper_type=("jpg" "png" "jepg")

type_file=""
for type in "${wallpaper_type[@]}"; do
    type_file="$type_file -o -name \"*.${type}"\"
done

type_file="${type_file#-o}"

# 设置壁纸切换时间
interval=15

while true; do
    wallpaper=$(find "$wallpaper_dir" -type f \( "$type_file" \) | shuf -n |)    
    swaybg -i "$wallpaper" -m fill &>/dev/null
    sleep 5
done

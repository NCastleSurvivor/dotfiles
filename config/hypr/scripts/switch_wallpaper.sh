#!/bin/bash

# 壁纸存放的目录
wallpaper_dir="$HOME/.config/hypr/wallpaper"

# 获取目录中的所有图片文件
wallpapers=("$wallpaper_dir"/*)

# 随机选择一个图片文件
random_wallpaper="${wallpapers[RANDOM % ${#wallpapers[@]} + 1]}"

# 使用swaybg设置壁纸
swaybg -i "$random_wallpaper" -m fill


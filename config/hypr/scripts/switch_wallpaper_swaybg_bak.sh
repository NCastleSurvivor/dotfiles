#!/bin/bash

# 壁纸存放的目录
wallpaper_dir="$HOME/.config/hypr/wallpaper"
#echo "wallpaper_dir : $wallpaper_dir"
# 显示器名称可通过'hyprctl monitors'查询
monitor_name="eDP-1"

# 设置壁纸切换时间
interval=15

# 日志文件路径
log_file="/home/zero/.cache/hyprpaper/switch_wallpaper.log"

# 日志记录函数
log_message(){
    if [ -n "$log_file" ]; then
        mkdir -p "$(dirname "$log_file")" 2>/dev/null
        touch "$log_file" 2>/dev/null
        echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" >> "log_file"
    fi
}

# 获取壁纸文件列表
get_random_wallpaper_files() {
    # 设置支持的壁纸类型
    local valid_extensions=("jpg" "png" "jpeg")
    local count=0
    local random_index=0
    while IFS= read -r -d $'\0' file; do
        local ext="${file##*.}"
        for valid_ext in "${valid_extensions[@]}"; do
            if [ "$ext" = "$valid_ext" ]; then
                count=$((count + 1))
                if [ $((RANDOM % count)) -eq 0 ]; then
                    random_index=$count
                    selected_wallpaper="$file"
                fi
            fi
        done
    done < <(find "$wallpaper_dir" -type f -print0)
    echo "$selected_wallpaper"
}

# 切换壁纸函数
change_wallpaper() {
    start_time=$(date + %s)
    local selected_wallpaper=$(get_random_wallpaper_files)
    echo "selected wallpaper : $selected_wallpaper"
    if [ -z "$selected_wallpaper" ]; then
        log_message "壁纸目录内未找到有效壁纸文件！！！"
        return 0
    fi
    # 使用swaybg切换壁纸
    swaybg -i "$selected_wallpaper" -m fill 
    #hyprpaper --set-wallpaper "$selected_wallpaper" --monitor "$monitor_name"
    log_message "Wallpaper changed to : $selected_wallpaper"
    end_time=$(date + %s)
    echo "运行时间: $((end_time - start_time))s"
    return 0
}

# 主循环
while true ; do
    change_wallpaper
    echo "休眠 $interval"
    sleep $interval
    echo "woke up"
done


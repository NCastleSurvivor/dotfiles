#!/usr/bin/env bash

## Copyright (C) 2023 Ticks <ticks.cc@gmail.com>
##
## Set volume in hyprland
##

notify_cmd='dunstify -u low -h string:x-dunst-stack-tag:obvolume'

get_volume() {
	echo "$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | head -1 | awk -F: '{print ($2)*100}' | sed -e 's/\s//g')"
}

get_icon() {
	echo ""
}

notify_user() {
	${notify_cmd} "Volume: $(get_volume)"
}

inc_volume() {
#	if [[ "$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk -F: '{print $2}')" < "1.0" ]]; then
	if [[ $(get_volume) -lt 100 ]]; then
		wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ && notify_user
	else
		${notify_cmd} "The volume has reached its maximum value"
	fi
#	pactl set-sink-volume @DEFAULT_SINK@ +5% && notify_user
}
dec_volume() {
       	wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && notify_user
#	pactl set-sink-volume @DEFAULT_SINK@ -5% && notify_user
}

toggle_volume() {
	if [[ "$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $3}')" == "[MUTED]" ]]; then
		wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 toggle && ${notify_cmd} "UNMUTE"
	else
		wpctl set-mute @DEFAULT_AUDIO_SINK@ 1 toggle && ${notify_cmd} "MUTED"
	fi
}

if [[ -x $(which wpctl) ]]; then
	if [[ "$1" == "--get" ]]; then
		get_volume
	elif [[ "$1" == "--inc" ]]; then
		inc_volume
	elif [[ "$1" == "--dec" ]]; then
		dec_volume
	elif [[ "$1" == "--toggle" ]]; then
		toggle_volume
	else
		echo "$(get_volume)"
	fi
else
	${notify_cmd} "'wpctl' not found !"
fi

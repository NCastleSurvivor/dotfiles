#!/bin/bash

# Function to connect to a Wi-Fi network
connect_to_wifi() {
    local ssid="$1"
    local password="$2"
    nmcli device wifi connect "$ssid" password "$password"
}

# Function to add a new Wi-Fi network
add_wifi_network() {
    local ssid="$1"
    local password="$2"
    nmcli device wifi connect "$ssid" password "$password"
}

# Function to refresh the Wi-Fi list
refresh_wifi_list() {
    nmcli device wifi rescan
}

# Function to show a notification
show_notification() {
    local message="$1"
    notify-send "Wi-Fi Manager" "$message"
}

# Function to show the Wi-Fi menu and handle password input and retries
show_wifi_menu() {
    local selected_ssid=""
    local password=""
    local attempt_count=0

    while true; do
        # Refresh the Wi-Fi list
        refresh_wifi_list

        # Get the list of available Wi-Fi networks
        #wifi_list=$(nmcli -t -f SSID,BSSID,IN-USE dev wifi list | awk '{print $1}')
	wifi_list=$(nmcli -t -f SSID,BSSID,IN-USE,SIGNAL dev wifi | awk -F: '{print $1}')

        # Display the list of Wi-Fi networks using rofi
        selected_ssid=$(echo -e "Refish\nAdd\n$wifi_list" | rofi -dmenu -i -p "Select Wi-Fi network: " -no-custom)

        # If Escape is pressed, break the loop
        if [ -z "$selected_ssid" ]; then
            break
        fi

        # If Refresh button is pressed, refresh the Wi-Fi list and continue the loop
        if [ "$selected_ssid" == "Refish" ]; then
            continue
        fi

        # If Add button is pressed, prompt for new Wi-Fi network information and attempt to connect
        if [ "$selected_ssid" == "Add" ]; then
            local new_ssid=$(rofi -dmenu -p "Enter Wi-Fi name (SSID): ")
            local new_password=$(rofi -dmenu -i -password -p "Enter password for $new_ssid: ")
            if [ -n "$new_ssid" ] && [ -n "$new_password" ]; then
                add_wifi_network "$new_ssid" "$new_password"
                local connection_status=$?
                if [ $connection_status -eq 0 ]; then
                    show_notification "Successfully connected to $new_ssid."
                    break
                else
                    show_notification "Failed to connect to $new_ssid. Please try again."
                fi
            else
                show_notification "SSID and password cannot be empty. Please try again."
            fi
            continue
        fi

        # Prompt for Wi-Fi password
        password=$(rofi -dmenu -i -password -p "Enter password for $selected_ssid: ")

        # If password is not empty, try to connect to the Wi-Fi
        if [ -n "$password" ]; then
            connect_to_wifi "$selected_ssid" "$password"
            if [ $? -eq 0 ]; then
                show_notification "Successfully connected to $selected_ssid."
                break
            else
                show_notification "Incorrect password for $selected_ssid. Please try again."
                attempt_count=$((attempt_count + 1))
            fi
        else
            show_notification "Password cannot be empty. Please try again."
        fi

        # If there are three incorrect password attempts, refresh the Wi-Fi list and restart the menu
        if [ $attempt_count -ge 3 ]; then
            show_notification "Too many incorrect attempts. Refreshing Wi-Fi list."
            attempt_count=0
        fi
    done
}

# Main function to start the script
main() {
    # Display the Wi-Fi menu
    show_wifi_menu
}

# Execute the main function
main


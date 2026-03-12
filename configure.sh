#!/bin/bash

# Default values
default_tv_ip="192.168.X.X"
default_tv_mac="XX:XX:XX:XX:XX:XX"
default_pc_input="HDMI_1"

# Check for existing installation
installed_file="/usr/bin/LG_Buddy_Startup"
local_file="bin/LG_Buddy_Startup"

target_file=""
if [ -f "$installed_file" ]; then
    target_file="$installed_file"
    echo "Existing installation detected. Reading current configuration..."
elif [ -f "$local_file" ]; then
    target_file="$local_file"
fi

if [ -n "$target_file" ]; then
    # Extract values
    extracted_ip=$(grep -m 1 '^tv_ip=' "$target_file" | cut -d'"' -f2)
    extracted_mac=$(grep -m 1 '^tv_mac=' "$target_file" | cut -d'"' -f2)
    extracted_input=$(grep -m 1 '^input=' "$target_file" | cut -d'"' -f2)

    [ -n "$extracted_ip" ] && default_tv_ip="$extracted_ip"
    [ -n "$extracted_mac" ] && default_tv_mac="$extracted_mac"
    [ -n "$extracted_input" ] && default_pc_input="$extracted_input"
fi

read -p "Enter your TV's IP address [$default_tv_ip]: " tv_ip
tv_ip=${tv_ip:-$default_tv_ip}

read -p "Enter your TV's MAC address [$default_tv_mac]: " tv_mac
tv_mac=${tv_mac:-$default_tv_mac}

read -p "Enter your PC's input (e.g., HDMI_1, HDMI_4) [$default_pc_input]: " pc_input
pc_input=${pc_input:-$default_pc_input}

echo "Updating configuration files..."

TARGET_DIR=${1:-bin}

sed -i "s/tv_ip=\"[^\"]*\"/tv_ip=\"$tv_ip\"/" "$TARGET_DIR"/LG_Buddy_Startup
sed -i "s/tv_mac=\"[^\"]*\"/tv_mac=\"$tv_mac\"/" "$TARGET_DIR"/LG_Buddy_Startup
sed -i "s/input=\"[^\"]*\"/input=\"$pc_input\"/" "$TARGET_DIR"/LG_Buddy_Startup

sed -i "s/tv_ip=\"[^\"]*\"/tv_ip=\"$tv_ip\"/" "$TARGET_DIR"/LG_Buddy_Shutdown
sed -i "s/input=\"[^\"]*\"/input=\"$pc_input\"/" "$TARGET_DIR"/LG_Buddy_Shutdown

sed -i "s/tv_ip=\"[^\"]*\"/tv_ip=\"$tv_ip\"/" "$TARGET_DIR"/LG_Buddy_sleep_pre
sed -i "s/input=\"[^\"]*\"/input=\"$pc_input\"/" "$TARGET_DIR"/LG_Buddy_sleep_pre

sed -i "s/tv_ip=\"[^\"]*\"/tv_ip=\"$tv_ip\"/" "$TARGET_DIR"/LG_Buddy_sleep
sed -i "s/input=\"[^\"]*\"/input=\"$pc_input\"/" "$TARGET_DIR"/LG_Buddy_sleep

sed -i "s/tv_ip=\"[^\"]*\"/tv_ip=\"$tv_ip\"/" "$TARGET_DIR"/LG_Buddy_Screen_Off
sed -i "s/input=\"[^\"]*\"/input=\"$pc_input\"/" "$TARGET_DIR"/LG_Buddy_Screen_Off

sed -i "s/tv_ip=\"[^\"]*\"/tv_ip=\"$tv_ip\"/" "$TARGET_DIR"/LG_Buddy_Screen_On
sed -i "s/tv_mac=\"[^\"]*\"/tv_mac=\"$tv_mac\"/" "$TARGET_DIR"/LG_Buddy_Screen_On
sed -i "s/input=\"[^\"]*\"/input=\"$pc_input\"/" "$TARGET_DIR"/LG_Buddy_Screen_On

echo "Configuration updated successfully."

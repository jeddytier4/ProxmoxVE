#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/jeddytier4/ProxmoxVE/refs/heads/FoundryVTT/misc/build.func)
# Copyright (c) 2021-2025 tteck
# Author: tteck (tteckster)
# License: MIT | https://github.com/community-scripts/ProxmoxVE/raw/main/LICENSE

# App Default Values
APP="FoundryVTT"
var_tags="foundry;vtt;alpine"  
var_cpu="1"
var_ram="2048"
var_disk="8"
var_os="alpine"
var_version="3.20"
var_unprivileged="1"

# App Output & Base Settings
header_info "$APP"
base_settings

# Core
variables
color
catch_errors

if VTT_TEMP_URL=$(whiptail --backtitle "Proxmox VE Helper Scripts" --inputbox "Set Foundry Download Url" 8 58 --title "FoundryVTT Temp Download Url" --cancel-button Exit-Script 3>&1 1>&2 2>&3); then

else
  exit-script
fi
function update_script() {
  UPD=$(whiptail --backtitle "Proxmox VE Helper Scripts" --title "SUPPORT" --radiolist --cancel-button Exit-Script "Spacebar = Select" 11 58 1 \
    "1" "Check for Alpine Updates" ON \
    3>&1 1>&2 2>&3)

  header_info
  if [ "$UPD" == "1" ]; then
    apk update && apk upgrade
    exit
  fi
}

start
build_container
description

msg_ok "Completed Successfully!\n"

#!/usr/bin/env bash

# Copyright (c) 2021-2025 tteck
# Author: tteck (tteckster)
# License: MIT
# https://github.com/community-scripts/ProxmoxVE/raw/main/LICENSE
source /dev/stdin <<< "$FUNCTIONS_FILE_PATH"

color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing Dependencies"
$STD apk add newt
$STD apk add curl
$STD apk add openssh
$STD apk add nano
$STD apk add mc
$STD apk add unzip
$STD apk add nodejs
$STD apk add npm
msg_ok "Installed Dependencies"
$STD adduser -S foundry
msg_info "Installing FoundryVTT"
FOUNDRY_APP_DIR="/home/foundry"
FOUNDRY_DATA_DIR="/data/foundry"
mkdir -p "$FOUNDRY_APP_DIR" "$FOUNDRY_DATA_DIR"
msg_info "Downloading FoundryVTT"
wget -q -O "$FOUNDRY_APP_DIR/foundryvtt.zip" "$VTT_TEMP_URL"
msg_ok "Downloading FoundryVTT"
msg_info "Expanding FoundryVTT"
unzip -qq -o "$FOUNDRY_APP_DIR/foundryvtt.zip" -d "$FOUNDRY_APP_DIR"
chown -R foundry: "$FOUNDRY_APP_DIR" "$FOUNDRY_DATA_DIR"
msg_ok "Expanding FoundryVTT"
npm install pm2@latest -g --no-fund --silent

msg_info "Starting FoundryVTT"
pm2 start --silent "$FOUNDRY_APP_DIR/resources/app/main.js" --name foundry --user foundry -- --dataPath="$FOUNDRY_DATA_DIR"

# Allow PM2 to start at boot
pm2 startup --silent
pm2 save --silent
mkdir -p "$FOUNDRY_DATA_DIR/Config/"
motd_ssh
customize
cat > "$FOUNDRY_DATA_DIR/Config/options.json" <<EOF
{
  "port": 30000,
  "upnp": true,
  "fullscreen": false,
  "hostname": "${APP}",
  "localHostname": null,
  "routePrefix": null,
  "sslCert": null,
  "sslKey": null,
  "awsConfig": null,
  "dataPath": "${FOUNDRY_DATA_DIR}",
  "passwordSalt": null,
  "proxySSL": true,
  "proxyPort": 443,
  "serviceConfig": null,
  "updateChannel": "stable",
  "language": "en.core",
  "upnpLeaseDuration": null,
  "compressStatic": true,
  "world": null
}
EOF

# Restart Foundry to take proxying into account
# pm2 restart foundry --silent

msg_ok "FoundryVTT Installed"
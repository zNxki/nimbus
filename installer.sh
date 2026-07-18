#!/usr/bin/env bash
set -e

CYAN='\033[96m'
GREEN='\033[92m'
RESET='\033[0m'

echo -e "${CYAN}"
cat << "EOF"
 _   _ _           _
| \ | (_)_ __ ___ | |__  _   _ ___
|  \| | | '_ ` _ \| '_ \| | | / __|
| |\  | | | | | | | |_) | |_| \__ \
|_| \_|_|_| |_| |_|_.__/ \__,_|___/
EOF
echo -e "${RESET}Installing Nimbus...\n"

if ! command -v rclone &> /dev/null; then
    echo "Installing rclone..."
    sudo apt update
    sudo apt install -y rclone
fi

if ! command -v python3 &> /dev/null; then
    echo "Installing python3..."
    sudo apt install -y python3
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
sudo cp "$SCRIPT_DIR/nimbus" /usr/local/bin/nimbus
sudo chmod +x /usr/local/bin/nimbus

echo -e "\n${GREEN}✔ Nimbus installed successfully!${RESET}"
echo "Try:      nimbus --help"
echo "Connect:  nimbus set GOOGLE_DRIVE"
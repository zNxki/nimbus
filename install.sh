#!/usr/bin/env bash
set -e

CYAN='\033[96m'
GREEN='\033[92m'
YELLOW='\033[93m'
RED='\033[91m'
RESET='\033[0m'

REPO_RAW_URL="https://raw.githubusercontent.com/zNxki/nimbus/main"
ACTION="${1:-install}"

banner() {
    echo -e "${CYAN}"
    cat << "EOF"
 _   _ _           _
| \ | (_)_ __ ___ | |__  _   _ ___
|  \| | | '_ ` _ \| '_ \| | | / __|
| |\  | | | | | | | |_) | |_| \__ \
|_| \_|_|_| |_| |_|_.__/ \__,_|___/
EOF
    echo -e "${RESET}"
}

detect_pm() {
    if command -v apt &> /dev/null; then
        PM="apt"; INSTALL_CMD="sudo apt update && sudo apt install -y"
    elif command -v pacman &> /dev/null; then
        PM="pacman"; INSTALL_CMD="sudo pacman -Sy --noconfirm"
    elif command -v dnf &> /dev/null; then
        PM="dnf"; INSTALL_CMD="sudo dnf install -y"
    else
        echo -e "${YELLOW}Could not detect apt, pacman, or dnf.${RESET}"
        echo "Please install 'rclone' and 'python3' manually, then re-run this script."
        exit 1
    fi
    echo -e "${CYAN}Detected package manager: ${PM}${RESET}"
}

fetch_nimbus_binary() {
    # If running from a local clone (nimbus file next to this script), use it.
    # Otherwise (e.g. curl | bash), download it straight from GitHub.
    SCRIPT_DIR=""
    if [ -n "${BASH_SOURCE[0]:-}" ] && [ -f "$(dirname "${BASH_SOURCE[0]}")/nimbus" ]; then
        SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    fi

    if [ -n "$SCRIPT_DIR" ]; then
        sudo cp "$SCRIPT_DIR/nimbus" /usr/local/bin/nimbus
    else
        echo "Downloading nimbus from GitHub..."
        sudo curl -fsSL "$REPO_RAW_URL/nimbus" -o /usr/local/bin/nimbus
    fi
    sudo chmod +x /usr/local/bin/nimbus
}

do_install() {
    banner
    echo -e "Installing Nimbus...\n"
    detect_pm

    if ! command -v rclone &> /dev/null; then
        echo "Installing rclone..."
        eval "$INSTALL_CMD rclone"
    fi
    if ! command -v python3 &> /dev/null; then
        echo "Installing python3..."
        eval "$INSTALL_CMD python3"
    fi

    fetch_nimbus_binary

    echo -e "\n${GREEN}✔ Nimbus installed successfully!${RESET}"
    echo "Try:      nimbus --help"
    echo "Connect:  nimbus set GOOGLE_DRIVE"
}

do_update() {
    banner
    if ! command -v nimbus &> /dev/null; then
        echo -e "${YELLOW}Nimbus is not installed yet. Run: ./install.sh install${RESET}"
        exit 1
    fi
    echo "Updating Nimbus (config and backups are left untouched)..."
    fetch_nimbus_binary
    echo -e "\n${GREEN}✔ Nimbus updated to the latest version.${RESET}"
    nimbus --version
}

do_uninstall() {
    banner
    if ! command -v nimbus &> /dev/null; then
        echo -e "${YELLOW}Nimbus doesn't seem to be installed.${RESET}"
        exit 0
    fi

    read -p "Remove the nimbus command? [y/N] " confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        echo "Aborted."
        exit 0
    fi
    sudo rm -f /usr/local/bin/nimbus
    echo -e "${GREEN}✔ Removed /usr/local/bin/nimbus${RESET}"

    # remove the cron job, if any
    if crontab -l 2>/dev/null | grep -q "NIMBUS-BACKUP-JOB"; then
        crontab -l | grep -v "NIMBUS-BACKUP-JOB" | crontab -
        echo -e "${GREEN}✔ Removed scheduled backup job${RESET}"
    fi

    read -p "Also delete config and logs (~/.config/nimbus)? [y/N] " confirm2
    if [[ "$confirm2" =~ ^[Yy]$ ]]; then
        rm -rf "$HOME/.config/nimbus" "$HOME/.local/share/nimbus"
        echo -e "${GREEN}✔ Removed config, logs and staging data${RESET}"
    else
        echo -e "${CYAN}Kept config at ~/.config/nimbus${RESET}"
    fi

    echo -e "\n${GREEN}Nimbus has been uninstalled.${RESET}"
}

case "$ACTION" in
    install)   do_install ;;
    update)    do_update ;;
    uninstall) do_uninstall ;;
    *)
        echo "Usage: ./install.sh [install|update|uninstall]"
        exit 1
        ;;
esac
#!/usr/bin/env bash
set -e

CYAN='\033[96m'
GREEN='\033[92m'
YELLOW='\033[93m'
RESET='\033[0m'

REPO_RAW_URL="https://raw.githubusercontent.com/zNxki/nimbus/main"

echo -e "${CYAN}"
cat << "EOF"
 _   _ _           _
| \ | (_)_ __ ___ | |__  _   _ ___
|  \| | | '_ ` _ \| '_ \| | | / __|
| |\  | | | | | | | |_) | |_| \__ \
|_| \_|_|_| |_| |_|_.__/ \__,_|___/
EOF
echo -e "${RESET}Installing Nimbus...\n"

# ---- detect package manager ----
if command -v apt &> /dev/null; then
    PM="apt"
    INSTALL_CMD="sudo apt update && sudo apt install -y"
elif command -v pacman &> /dev/null; then
    PM="pacman"
    INSTALL_CMD="sudo pacman -Sy --noconfirm"
elif command -v dnf &> /dev/null; then
    PM="dnf"
    INSTALL_CMD="sudo dnf install -y"
else
    echo -e "${YELLOW}Could not detect apt, pacman, or dnf.${RESET}"
    echo "Please install 'rclone' and 'python3' manually, then re-run this script."
    exit 1
fi

echo -e "${CYAN}Detected package manager: ${PM}${RESET}"

if ! command -v rclone &> /dev/null; then
    echo "Installing rclone..."
    eval "$INSTALL_CMD rclone"
fi

if ! command -v python3 &> /dev/null; then
    echo "Installing python3..."
    eval "$INSTALL_CMD python3"
fi

# get the nimbus script itself 
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

echo -e "\n${GREEN}✔ Nimbus installed successfully!${RESET}"
echo "Try:      nimbus --help"
echo "Connect:  nimbus set GOOGLE_DRIVE"
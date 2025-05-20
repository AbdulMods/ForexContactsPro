#!/bin/bash

clear

# Color codes
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
MAGENTA='\033[1;35m'
NC='\033[0m'

# ASCII Header
echo -e "${BLUE}
███████╗ ██████╗ ██████╗ ███████╗██╗  ██╗
██╔════╝██╔═══██╗██╔══██╗██╔════╝╚██╗██╔╝
█████╗  ██║   ██║██████╔╝█████╗   ╚███╔╝ 
██╔══╝  ██║   ██║██╔══██╗██╔══╝   ██╔██╗ 
██║     ╚██████╔╝██║  ██║███████╗██╔╝ ██╗
╚═╝      ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝
${NC}"

# Disclaimer
echo -e "${RED}IMPORTANT:${NC}
${YELLOW}1. This tool is provided by Trade With Qadeer (Abdul Qadeer Gabol).
2. Use it strictly for educational purposes only.
3. You are solely responsible for any action performed using this tool.
4. The developer/owner is NOT liable for any misuse or illegal activity.${NC}"

# Menu
echo -e "${CYAN}\n1) I Agree"
echo "2) Exit${NC}"
read -p $'\nSelect an option (1 or 2): ' choice

if [[ "$choice" != "1" ]]; then
    echo -e "${RED}Installation aborted. You did not accept the terms.${NC}"
    exit 1
fi

clear

# Detect OS
if [[ $(uname -o 2>/dev/null) == *Android* ]]; then
    OS="termux"
    BIN_DIR="$PREFIX/bin"
else
    OS="ubuntu"
    BIN_DIR="/usr/local/bin"
fi

mkdir -p "$BIN_DIR"

# Progress bar
show_progress() {
    local msg=$1
    echo -ne "${MAGENTA}$msg${NC}\n"
    local bar=""
    for i in {1..50}; do
        bar+="#"
        printf "\r[%-50s] %d%%" "$bar" "$((2 * i))"
        sleep 0.03
    done
    echo
}

# Step log
step() {
    echo -e "${YELLOW}➤ $1${NC}"
    sleep 1
}

# Installation
install_all() {
    step "Requesting Storage Permission for Termux"
if [[ "$OS" == "termux" ]]; then
    termux-setup-storage
else
    echo "No storage permission needed on Ubuntu"
fi
    step "Updating package lists..."
    if [[ "$OS" == "termux" ]]; then
        pkg update -y
    else
        sudo apt update -y
    fi

    step "Installing Python..."
    if [[ "$OS" == "termux" ]]; then
        pkg install -y python
    else
        sudo apt install -y python3
    fi

    step "Installing Git..."
    if [[ "$OS" == "termux" ]]; then
        pkg install -y git
    else
        sudo apt install -y git
    fi

    step "Installing Figlet (optional)..."
    if [[ "$OS" == "termux" ]]; then
        pkg install -y figlet
    else
        sudo apt install -y figlet
    fi

    step "Checking for existing ForexContactsPro directory..."
    if [ -d "ForexContactsPro" ]; then
        echo -e "${RED}Old repository found. Removing...${NC}"
        rm -rf ForexContactsPro
    fi

    step "Cloning fresh repository..."
    git clone https://github.com/AbdulMods/ForexContactsPro.git

    step "Creating launcher script..."
    echo -e "#!/bin/bash\ncd $(pwd)/ForexContactsPro && python3 Qadeer.py" > "$BIN_DIR/qadeer"
    chmod +x "$BIN_DIR/qadeer"

    if [[ "$OS" == "ubuntu" ]]; then
        sudo apt-get clean
    fi

    show_progress "Finishing setup..."
}

# Run installation
install_all

# Final message
echo -e "\n${GREEN}✓ Installation Complete!${NC}"
echo -e "${MAGENTA}Thanks to the creator: Abdul Qadeer Gabol (Trade With Qadeer)${NC}"
echo -e "${YELLOW}WARNING:${NC} ${RED}The owner is NOT responsible for your actions or any misuse of this tool.${NC}"
echo -e "${CYAN}Use it wisely and for educational purposes only.${NC}"

# Launch
read -p $'\nPress Enter to launch the tool...' _
clear
qadeer

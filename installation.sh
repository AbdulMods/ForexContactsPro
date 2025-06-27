#!/bin/bash

clear

# Enhanced Color Scheme
RED='\033[1;91m'
GREEN='\033[1;92m'
YELLOW='\033[1;93m'
BLUE='\033[1;94m'
CYAN='\033[1;96m'
MAGENTA='\033[1;95m'
PURPLE='\033[1;35m'
ORANGE='\033[1;33m'
NC='\033[0m'

# Beautiful ASCII Header with Gradient
echo -e "${BLUE}╔══════════════════════════════════════════════════╗"
echo -e "${CYAN}║${BLUE} ███████╗ ██████╗ ██████╗ ███████╗██╗  ██╗ ${CYAN}║"
echo -e "${CYAN}║${GREEN} ██╔════╝██╔═══██╗██╔══██╗██╔════╝╚██╗██╔╝ ${CYAN}║"
echo -e "${CYAN}║${YELLOW} █████╗  ██║   ██║██████╔╝█████╗   ╚███╔╝  ${CYAN}║"
echo -e "${CYAN}║${RED} ██╔══╝  ██║   ██║██╔══██╗██╔══╝   ██╔██╗  ${CYAN}║"
echo -e "${CYAN}║${MAGENTA} ██║     ╚██████╔╝██║  ██║███████╗██╔╝ ██╗ ${CYAN}║"
echo -e "${CYAN}║${PURPLE} ╚═╝      ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝ ${CYAN}║"
echo -e "${BLUE}╚══════════════════════════════════════════════════╝${NC}"

# Fixed Choice Prompt
echo -ne "\n${YELLOW}➤ ${CYAN}Your choice [${GREEN}1${CYAN}/${RED}2${CYAN}]: ${NC}"
read choice

if [[ "$choice" != "1" ]]; then
    echo -e "\n${RED}✗ Installation aborted. Terms not accepted.${NC}"
    exit 1
fi

clear

# Detect OS
if [[ $(uname -o 2>/dev/null) == *Android* ]]; then
    OS="termux"
    BIN_DIR="$PREFIX/bin"
    echo -e "${GREEN}✓ Running on ${CYAN}Termux${GREEN} (Android)${NC}"
else
    OS="ubuntu"
    BIN_DIR="/usr/local/bin"
    echo -e "${GREEN}✓ Running on ${CYAN}Ubuntu/Linux${NC}"
fi
sleep 1

mkdir -p "$BIN_DIR"

# Enhanced progress bar with emojis
show_progress() {
    local msg=$1
    local emoji=$2
    echo -ne "\n${PURPLE}${emoji} ${MAGENTA}${msg}${NC}\n"
    local bar=""
    local spin=("-" "\\" "|" "/")
    local spin_idx=0
    for i in {1..50}; do
        bar+="▓"
        printf "\r${CYAN}[${GREEN}%-50s${CYAN}] ${YELLOW}%d%% ${spin[${spin_idx}]}" "$bar" "$((2 * i))"
        ((spin_idx = (spin_idx + 1) % 4))
        sleep 0.03
    done
    echo -e "\n${GREEN}✓ Completed!${NC}"
}

# Step log with cool icons
step() {
    local emoji=$2
    echo -e "\n${YELLOW}${emoji} ➤ ${CYAN}$1${NC}"
    sleep 0.3
}

# Package installer with retry and cool status
install_package() {
    local pkg="$1"
    local max_retries=3
    local attempt=1
    local success=0
    
    if [[ "$OS" == "termux" ]]; then
        while [[ $attempt -le $max_retries ]]; do
            if pkg install -y "$pkg" 2>/dev/null; then
                success=1
                break
            else
                echo -e "${RED}⛔ Attempt $attempt failed for $pkg. Retrying...${NC}"
                ((attempt++))
                sleep 1
            fi
        done
    else
        while [[ $attempt -le $max_retries ]]; do
            if sudo apt install -y "$pkg" 2>/dev/null; then
                success=1
                break
            else
                echo -e "${RED}⛔ Attempt $attempt failed for $pkg. Retrying...${NC}"
                ((attempt++))
                sleep 1
            fi
        done
    fi
    
    if [[ $success -eq 1 ]]; then
        echo -e "${GREEN}✓ $pkg installed successfully${NC}"
        return 0
    else
        echo -e "${RED}✗ Critical failure installing $pkg after $max_retries attempts${NC}"
        return 1
    fi
}


# Installation process
install_all() {
    if [[ "$OS" == "termux" ]]; then
        step "Requesting Storage Permission" "📱"
        termux-setup-storage
        sleep 1
    fi

    step "Updating package repositories" "🔄"
    if [[ "$OS" == "termux" ]]; then
        pkg update -y >/dev/null 2>&1
    else
        sudo apt update -y >/dev/null 2>&1
    fi

    # Install essential packages
    step "Installing Python" "🐍"
    if [[ "$OS" == "termux" ]]; then
        install_package python || return 1
    else
        install_package python3 || return 1
    fi

    step "Installing Git" "🌐"
    install_package git || return 1

    step "Installing Figlet" "✨"
    install_package figlet

    # Clean existing installation
    step "Checking for previous installations" "🧹"
    if [ -d "ForexContactsPro" ]; then
        echo -e "${RED}Removing old repository...${NC}"
        rm -rf ForexContactsPro
    fi

    # Clone repository
    step "Cloning repository" "📥"
    if git clone https://github.com/AbdulMods/ForexContactsPro.git; then
        echo -e "${GREEN}✓ Repository cloned successfully${NC}"
    else
        echo -e "${RED}✗ Failed to clone repository. Check internet connection${NC}"
        return 1
    fi

    # Create launcher
    step "Creating launcher script" "🚀"
    echo -e "#!/bin/bash\ncd $(pwd)/ForexContactsPro && python3 Qadeer.py" > "$BIN_DIR/pro-contacts"
    if chmod +x "$BIN_DIR/pro-contacts"; then
        echo -e "${GREEN}✓ Launcher created at $BIN_DIR/qadeer${NC}"
    else
        echo -e "${RED}✗ Failed to create launcher script${NC}"
        return 1
    fi

    # Cleanup
    if [[ "$OS" == "ubuntu" ]]; then
        sudo apt-get clean >/dev/null
    fi

    show_progress "Finalizing installation" "⚡"
    return 0
}

# Run installation with cool animation
echo -e "\n${PURPLE}🚀 Starting installation process...${NC}"
sleep 1

if install_all; then
    # Run terminal customization
    customize_terminal
    
    # Success animation
    echo -e "\n${GREEN}╔══════════════════════════════════════╗"
    echo -e "║          🎉 INSTALLATION SUCCESS!        ║"
    echo -e "╚══════════════════════════════════════╝${NC}"
else
    # Failure animation
    echo -e "\n${RED}╔══════════════════════════════════════╗"
    echo -e "║          ⚠️ INSTALLATION FAILED!         ║"
    echo -e "╚══════════════════════════════════════╝${NC}"
    exit 1
fi

# Final message with style
echo -e "\n${PURPLE}┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓"
echo -e "┃  ${CYAN}Tool created by: ${MAGENTA}Abdul Qadeer Gabol     ┃"
echo -e "┃  ${CYAN}         (Trade With Qadeer)          ┃"
echo -e "┃                                            ┃"
echo -e "┃  ${YELLOW}⚠️ ${RED}LEGAL DISCLAIMER: ${ORANGE}Use only for     ┃"
echo -e "┃  ${ORANGE}educational purposes. Owner NOT      ┃"
echo -e "┃  ${ORANGE}responsible for any misuse.          ┃"
echo -e "┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛${NC}"

# Launch prompt
if command -v qadeer &>/dev/null; then
    echo -e "\n${BLUE}👉 ${CYAN}Press Enter to launch the tool ${GREEN}OR"
    echo -e "${BLUE}👉 ${CYAN}Type 'qadeer' anytime to run it${NC}"
    read -p $'\n'"${YELLOW}➤ ${CYAN}Launch now? [${GREEN}Y${CYAN}/${RED}n${CYAN}]: ${NC}" launch
    
    if [[ "${launch,,}" != "n" ]]; then
        clear
        echo -e "${BLUE}🚀 Launching ForexContactsPro...${NC}\n"
        sleep 1
        qadeer
    else
        echo -e "\n${GREEN}You can launch anytime with: ${CYAN}qadeer${NC}"
    fi
else
    echo -e "\n${RED}⚠️ Launcher not found. Try these steps:"
    echo -e "1. Restart your terminal"
    echo -e "2. Run manually: ${CYAN}cd ForexContactsPro && python3 Qadeer.py${NC}"
fi

# Cool exit
echo -e "\n${PURPLE}✨ Thanks for using the installer! ✨${NC}"
 clear

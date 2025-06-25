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

# Customization 
customize_terminal() {
    if [[ "$OS" == "termux" ]]; then
        step "Customizing Termux terminal" "🎨"
        
        # Create custom bashrc with proper escaping
        cat > ~/../usr/etc/bash.bashrc << 'EOL'
#!/data/data/com.termux/files/usr/bin/bash

# Custom Trade Terminal
echo -e "\033[1;91m
  ____  ____  ____  ____ 
 /  _ \/  _ \/  _ \/  _ \
(  (_) )  (_) )  (_) )  (_) )
 \____/\____/\____/\____/
\033[0m"

echo -e "\033[1;92m❤️  Welcome to Trade Terminal!\033[0m"
echo -e "\033[1;93m📢  Educational Use Only - Trade Responsibly\033[0m"
echo -e "\033[1;94m© $(date +%Y) Trade. All rights reserved.\033[0m"
echo ""

# Show installed tools
echo -e "\033[1;96mInstalled Tools:\033[0m"
echo -e "  \033[1;95m• Trade Terminal\033[0m"
echo -e "    Run command: \033[1;97mqadeer\033[0m"
echo ""

# System information
echo -e "\033[1;96mSystem Info:\033[0m"
echo -e "  \033[1;95m• OS:\033[0m $(uname -o)"
echo -e "  \033[1;95m• Device:\033[0m $(getprop ro.product.model)"
echo -e "  \033[1;95m• Time:\033[0m $(date +%T)"
echo ""

# Custom prompt with colors, time and directory
PS1='\[\033[1;91m\]\t \[\033[1;92m\]Qadeer➤ \[\033[1;96m\]\w \[\033[1;91m\]\$ ___BLOCK_OPEN___\033[0m___BLOCK_CLOSE___'
EOL

        # Create custom motd
        cat > ~/../usr/etc/motd << 'EOL'
________________________________________________________
|                                                      |
|    ████████╗██████╗  █████╗ ██████╗ ███████╗         |
|    ╚══██╔══╝██╔══██╗██╔══██╗██╔══██╗██╔════╝         |
|       ██║   ██████╔╝███████║██║  ██║█████╗           |
|       ██║   ██╔══██╗██╔══██║██║  ██║██╔══╝           |
|       ██║   ██║  ██║██║  ██║██████╔╝███████╗         |
|       ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ╚══════╝         |
|                                                      |
| Trade Tool by Abdul Qadeer Gabol                     |
| Educational Use Only - Trade Responsibly             |
|______________________________________________________|
EOL

        echo -e "${GREEN}✓ Termux terminal customized successfully!${NC}"
        echo -e "${YELLOW}⚠️ Restart Termux to see the new look${NC}"
    else
        # Ubuntu customization
        echo -e "\n${CYAN}Would you like to install our custom terminal look for Ubuntu?${NC}"
        echo -ne "${YELLOW}➤ ${CYAN}Your choice [${GREEN}Y${CYAN}/${RED}n${CYAN}]: ${NC}"
        read ubuntu_choice
        
        if [[ "${ubuntu_choice,,}" != "n" ]]; then
            step "Customizing Ubuntu terminal" "🎨"
            
            # Backup existing bashrc
            if [ ! -f ~/.bashrc.bak ]; then
                cp ~/.bashrc ~/.bashrc.bak
                echo -e "${GREEN}✓ Created backup of .bashrc${NC}"
            fi

            # Append customizations to bashrc
            cat >> ~/.bashrc << 'EOL'

# Custom Trade Terminal Configuration
echo -e "\033[1;91m
  ____  ____  ____  ____ 
 /  _ \/  _ \/  _ \/  _ \
(  (_) )  (_) )  (_) )  (_) )
 \____/\____/\____/\____/
\033[0m"

echo -e "\033[1;92m❤️  Welcome to Trade Terminal!\033[0m"
echo -e "\033[1;93m📢  Educational Use Only - Trade Responsibly\033[0m"
echo -e "\033[1;94m© $(date +%Y) Trade. All rights reserved.\033[0m"
echo ""

# Show installed tools
echo -e "\033[1;96mInstalled Tools:\033[0m"
echo -e "  \033[1;95m• Trade Terminal\033[0m"
echo -e "    Run command: \033[1;97mqadeer\033[0m"
echo ""

# Custom prompt with time and directory
PS1='___BLOCK_OPEN___\033[1;91m___BLOCK_CLOSE___\t ___BLOCK_OPEN___\033[1;92m___BLOCK_CLOSE___Qadeer➤ ___BLOCK_OPEN___\033[1;96m___BLOCK_CLOSE___\w ___BLOCK_OPEN___\033[1;91m___BLOCK_CLOSE___\$ ___BLOCK_OPEN___\033[0m___BLOCK_CLOSE___'

# Custom ls colors
LS_COLORS='rs=0:di=01;94:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:'
export LS_COLORS
EOL

            echo -e "${GREEN}✓ Ubuntu terminal customized successfully!${NC}"
            echo -e "${YELLOW}⚠️ Restart your terminal to see the new look${NC}"
        else
            echo -e "${YELLOW}✓ Skipping Ubuntu terminal customization${NC}"
        fi
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
    echo -e "#!/bin/bash\ncd $(pwd)/ForexContactsPro && python3 Qadeer.py" > "$BIN_DIR/qadeer"
    if chmod +x "$BIN_DIR/qadeer"; then
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

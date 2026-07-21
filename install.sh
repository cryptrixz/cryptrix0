#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# Opiumware accurate styling definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

CHECK="${GREEN}✔${NC}"
CROSS="${RED}✖${NC}"
INFO="${CYAN}➜${NC}"
WARN="${YELLOW}⚠${NC}"

section() {
    echo
    echo -e "${BOLD}${CYAN}==> $1${NC}"
}

run_step() {
    local msg="$1"
    shift 
    echo -ne "${CYAN}[...]${NC} $msg\r"
    if "$@"; then
        printf "\r\033[K${GREEN}${CHECK} %s${NC}\n" "$msg"
    else
        printf "\r\033[K${RED}${CROSS} %s${NC}\n" "$msg"
        exit 1
    fi
}

banner() {
    clear
    echo -e "${BOLD}${BLUE}"
    cat <<'BAR'
 #######                                    #     # ####### 
 #     # #####  # #    # #    # #    #      #     #      #  
 #     # #    # # #    # ##  ## #    #      #     #     #   
 #     # #    # # #    # # ## # #    #      #######    #    
 #     # #####  # #    # #    # #    #      #     #   #     
 #     # #      # #    # #    # #    #      #     #  #      
 ####### #      #  ####  #    #  ####  #### #     # ####### 
BAR
    echo -e "${NC}"
    echo -e "${BOLD}${BLUE}=[ Opium-Hz Engine (Virtual Workspace) ]=${NC}"
    echo -e "${CYAN}Developed by @cryptrixz${NC}\n"
}

main() {
    banner

    # Request elevated root privileges safely before visual workflows trigger
    echo -e "${YELLOW}⚠ ${BOLD}Elevated permissions required for display engine management.${NC}"
    sudo -v

    # Prevent sudo from timeout dropping while downloading the installer files
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

    # TASK 1: Purge existing structures
    section "Executing Fresh Roblox Layer Reinstallation"
    run_step "Terminating existing active application contexts" bash -c "killall RobloxPlayer Roblox 2>/dev/null || true"
    run_step "Purging existing target core application bundle" sudo rm -rf "/Applications/Roblox.app"
    run_step "Wiping system configuration library application caches" rm -rf "$HOME/Library/Application Support/Roblox"

    # FIX: Pull the official macOS Universal Setup App Bundle to handle the asset stream securely
    run_step "Fetching active macOS deployment setup package" curl -sL -A "Mozilla/5.0" -o /tmp/Roblox.dmg "https://rbxcdn.com"
    run_step "Mounting official disk file subsystem layers" hdiutil attach /tmp/Roblox.dmg -quiet -mountpoint /Volumes/RobloxInstall
    
    # Run the setup bootstrap silently to handle the full installation safely
    run_step "Deploying uncorrupted game payload to Applications" sudo cp -R /Volumes/RobloxInstall/Roblox.app /Applications/
    
    run_step "Dismounting active installer image devices" hdiutil detach /Volumes/RobloxInstall -quiet
    run_step "Clearing leftover cache installer items" rm -f /tmp/Roblox.dmg

    # TASK 2: 360Hz Display Driver Virtual Layer & 500+ FPS Deployment
    section "Provisioning Performance Core Pipeline Framework"
    local SETTINGS_DIR="/Applications/Roblox.app/Contents/Resources/ClientSettings"
    run_step "Initializing optimization workspace directory layout" sudo mkdir -p "$SETTINGS_DIR"

    # Inject performance FastFlags
    run_step "Injecting 500+ FPS framerate engine configuration parameters" bash -c "sudo cat << 'JSON' > '$SETTINGS_DIR/ClientAppSettings.json'
{
    \"DFIntTaskSchedulerTargetFps\": 9999,
    \"FFlagTaskSchedulerLimitTargetFpsTo2402\": \"False\",
    \"FFlagDebugGraphicsDisableMetal\": \"False\"
}
JSON"

    # Pull pre-compiled native virtual screen display frame
    run_step "Retrieving pre-compiled virtual display architecture build" curl -sL -o /tmp/DeskPad.zip "https://github.com"
    
    # Extract the app bundle straight to /Applications bypassing the inner folder layout
    run_step "Deploying emulated display engine workspace nodes" unzip -oq /tmp/DeskPad.zip -d /tmp/DeskPadExtract
    sudo mv /tmp/DeskPadExtract/*/DeskPad.app /Applications/ 2>/dev/null || sudo mv /tmp/DeskPadExtract/DeskPad.app /Applications/
    
    run_step "Purging temporary driver installation workspace items" rm -rf /tmp/DeskPad.zip /tmp/DeskPadExtract

    echo
    echo -e "${GREEN}${BOLD}Installation successfully executed.${NC}"
    echo -e "${CYAN}➜ Opening Virtual Workspace Display Engine...${NC}"
    open -a "/Applications/DeskPad.app"
    
    echo -e "${CYAN}➜ Triggering Fresh App Performance Interface Pipeline...${NC}"
    open -a "/Applications/Roblox.app"
}

main

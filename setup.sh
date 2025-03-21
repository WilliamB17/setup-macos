#!/bin/bash

set -e  # Stop script on error

# Color definitions for better readability
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to display messages
log_message() {
    echo -e "${2:-$GREEN}$1${NC}"
}

# Function to check prerequisites
check_playbook() {
    local playbook_path="playbooks/$1"
    if [ ! -f "$playbook_path" ]; then
        log_message "❌ Playbook $playbook_path does not exist." "$RED"
        exit 1
    fi
}

# Function to request Git information
get_git_info() {
    # Check if git_vars.yml already exists
    if [ -f "git_vars.yml" ]; then
        log_message "✅ Using existing git_vars.yml configuration" "$GREEN"
        return 0
    fi

    log_message "\n📝 Git Configuration" "$BLUE"
    
    # Ask for name
    read -p "$(echo -e "${BLUE}Enter your full name for Git (e.g., John Doe): ${NC}")" git_name
    while [[ -z "$git_name" ]]; do
        log_message "❌ Name cannot be empty." "$RED"
        read -p "$(echo -e "${BLUE}Enter your full name for Git: ${NC}")" git_name
    done
    
    # Ask for email
    read -p "$(echo -e "${BLUE}Enter your Git email: ${NC}")" git_email
    while [[ ! "$git_email" =~ ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$ ]]; do
        log_message "❌ Invalid email format." "$RED"
        read -p "$(echo -e "${BLUE}Enter your Git email: ${NC}")" git_email
    done
    
    # Create temporary file for variables
    cat > git_vars.yml << EOF
git_user_name: "$git_name"
git_user_email: "$git_email"
EOF
    
    log_message "✅ Git information saved"
}

log_message "🚀 Starting Ansible installation on a new Mac (without Homebrew)..."

# Check if Python is installed
if ! command -v python3 &>/dev/null; then
    log_message "📦 Python is not installed. Downloading Python..." "$YELLOW"
    log_message "📦 Checking for available macOS updates..." "$YELLOW"
    if softwareupdate --list | grep -q "Command Line Tools"; then
        log_message "🔄 Installing Command Line Tools for macOS..." "$YELLOW"
        xcode-select --install
    else
        log_message "📦 Downloading Python..." "$YELLOW"
        curl -o python.pkg "https://www.python.org/ftp/python/3.11.6/python-3.11.6-macos11.pkg"
        sudo installer -pkg python.pkg -target /
        rm python.pkg
        log_message "✅ Python installed successfully."
    fi
else
    log_message "✅ Python is already installed."
fi

# Define venv directory
ANSIBLE_VENV="$HOME/.ansible-venv"

# Create venv if it doesn't exist
if [ ! -d "$ANSIBLE_VENV" ]; then
    log_message "📦 Creating virtual environment for Ansible..." "$YELLOW"
    python3 -m venv "$ANSIBLE_VENV"
    log_message "✅ Virtual environment created: $ANSIBLE_VENV"
else
    log_message "✅ Ansible virtual environment already exists."
fi

# Activate venv and install/upgrade pip
log_message "🔄 Activating virtual environment and updating pip..." "$YELLOW"
source "$ANSIBLE_VENV/bin/activate"
python3 -m pip install --upgrade pip

# Install Ansible in the virtual environment
log_message "📦 Installing Ansible..." "$YELLOW"
pip install ansible-core

# Install required Ansible collections
log_message "📦 Installing required Ansible collections..." "$YELLOW"
ansible-galaxy collection install community.general

log_message "✅ Ansible and required collections installed in virtual environment."

# Verify installation
if command -v ansible &>/dev/null; then
    log_message "✅ Ansible installed successfully! Version: $(ansible --version | head -n 1)"
    
    # Get Git information
    get_git_info
    
    # Check playbooks
    PLAYBOOKS=(
        "01-homebrew.yml"  # Install Homebrew and core tools
        "02-shell.yml"     # Configure ZSH and terminal
        "03-git.yml"       # Setup Git and GitHub
        "04-languages.yml" # Install programming languages
    )
    
    for playbook in "${PLAYBOOKS[@]}"; do
        check_playbook "$playbook"
    done
    
    log_message "🚀 Launching playbooks..."
    
    # Execute playbooks with error handling
    for playbook in "${PLAYBOOKS[@]}"; do
        log_message "▶️ Executing playbooks/$playbook..." "$YELLOW"
        if ansible-playbook "playbooks/$playbook" -e "@git_vars.yml"; then
            log_message "✅ $playbook executed successfully"
        else
            log_message "❌ Error executing $playbook" "$RED"
            rm -f git_vars.yml
            deactivate
            exit 1
        fi
    done
    
    # Clean up temporary file
    rm -f git_vars.yml
    
    # Deactivate virtual environment
    deactivate
    log_message "✅ Installation completed successfully!"
else
    log_message "❌ Problem during Ansible installation." "$RED"
    deactivate
    exit 1
fi


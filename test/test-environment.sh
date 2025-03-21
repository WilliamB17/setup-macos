#!/bin/bash

#=============================================================================
# Test Environment Limitations
#=============================================================================
# This test environment simulates a macOS environment for basic testing.
# However, several macOS-specific features will NOT work:
#
# 1. Package Management:
#    - Homebrew installation and commands
#    - macOS software updates (softwareupdate command)
#    - App Store installations
#
# 2. macOS Applications:
#    - iTerm2 installation and configuration
#    - Terminal.app specific features
#    - Any GUI application installation or configuration
#
# 3. System Preferences:
#    - defaults write commands for macOS preferences
#    - System settings modifications
#    - Keyboard/Mouse configurations
#
# 4. Font Management:
#    - Font installation via Homebrew
#    - System font registration
#
# 5. Security Features:
#    - Keychain access and configuration
#    - macOS security preferences
#    - FileVault configuration
#
# What WILL work:
# + Basic shell configuration (ZSH)
# + Git installation and configuration
# + Python and pip installation
# + ZSH plugins installation
# + Basic user environment setup
# + Shell aliases and functions
#
# Use this environment for:
# - Basic functionality testing
# - Shell script syntax verification
# - Ansible playbook structure validation
# - Configuration file syntax checking
#=============================================================================

# Color definitions
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Function to display messages
log_message() {
    echo -e "${2:-$GREEN}$1${NC}"
}

# Check if Docker is installed
if ! command -v docker &>/dev/null; then
    log_message "❌ Docker is not installed. Please install Docker first." "$RED"
    exit 1
fi

# Build the Docker image
log_message "🔨 Building Docker test environment..." "$YELLOW"
docker build -t setup-macos-test -f "$(dirname "$0")/Dockerfile" .

if [ $? -ne 0 ]; then
    log_message "❌ Failed to build Docker image" "$RED"
    exit 1
fi

# Run the container
log_message "🚀 Starting test environment..." "$YELLOW"
log_message "ℹ️  You will be dropped into a shell where you can run the setup script" "$BLUE"
log_message "ℹ️  To test the setup, run: ./setup.sh" "$BLUE"
log_message "ℹ️  To exit the test environment, type: exit" "$BLUE"

docker run -it --rm setup-macos-test

log_message "✅ Test environment cleaned up" 
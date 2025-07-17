#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default options
SKIP_APT=false
CONFIG_ONLY=false
ANSIBLE_ARGS=""

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to show usage
show_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --skip-apt        Skip apt update/install operations"
    echo "  --config-only     Only update configurations (skip package installs)"
    echo "  --tags TAGS       Pass specific tags to ansible-playbook"
    echo "  --help            Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0                    # Full setup"
    echo "  $0 --skip-apt         # Setup without apt operations"
    echo "  $0 --config-only      # Only update configs"
    echo "  $0 --tags neovim      # Only run neovim tasks"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --skip-apt)
            SKIP_APT=true
            shift
            ;;
        --config-only)
            CONFIG_ONLY=true
            SKIP_APT=true
            ANSIBLE_ARGS="--skip-tags packages"
            shift
            ;;
        --tags)
            ANSIBLE_ARGS="--tags $2"
            shift 2
            ;;
        --help)
            show_usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            show_usage
            exit 1
            ;;
    esac
done

if [ "$CONFIG_ONLY" = true ]; then
    echo -e "${BLUE}Updating configurations only...${NC}"
else
    echo -e "${BLUE}Installing dotfiles...${NC}"
fi

# Check dependencies (skip apt operations if requested)
if [ "$SKIP_APT" = false ]; then
    # Check if Python3 is installed
    if ! command_exists python3; then
        echo "Python3 is required but not installed. Installing..."
        sudo apt update
        sudo apt install -y python3
    fi

    # Check if pip is installed
    if ! command_exists pip3; then
        echo "Pip3 is required but not installed. Installing..."
        sudo apt update
        sudo apt install -y python3-pip
    fi
else
    echo -e "${YELLOW}Skipping apt operations...${NC}"
    # Still check if required tools exist
    if ! command_exists python3; then
        echo "Error: Python3 is required but not installed. Run without --skip-apt first."
        exit 1
    fi
    if ! command_exists pip3; then
        echo "Error: Pip3 is required but not installed. Run without --skip-apt first."
        exit 1
    fi
fi

# Check if Ansible is installed
if ! command_exists ansible; then
    echo "Ansible is required but not installed. Installing..."
    pip3 install --user ansible
fi

# Add local bin to PATH temporarily if it's not there
if [ -d "$HOME/.local/bin" ] && [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# Run the playbook
echo -e "${BLUE}Running Ansible playbook...${NC}"
if [ "$CONFIG_ONLY" = true ]; then
    ansible-playbook site.yml --ask-become-pass $ANSIBLE_ARGS
else
    ansible-playbook site.yml --ask-become-pass $ANSIBLE_ARGS
fi

echo -e "${GREEN}Setup complete!${NC}"
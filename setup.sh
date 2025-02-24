#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

echo -e "${BLUE}Installing dotfiles...${NC}"

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

# Check if Ansible is installed
if ! command_exists ansible; then
    echo "Ansible is required but not installed. Installing..."
    pip3 install --user ansible
fi

# Add local bin to PATH temporarily if it's not there
export PATH="$HOME/.local/bin:$PATH"

# Run the playbook
echo -e "${BLUE}Running Ansible playbook...${NC}"
ansible-playbook site.yml --ask-become-pass

echo -e "${GREEN}Installation complete!${NC}"
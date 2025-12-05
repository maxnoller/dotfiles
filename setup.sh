#!/bin/bash
# Bootstrap script - installs uv, installs dotfiles CLI as uv tool, and runs it

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${BLUE}=== Dotfiles Setup ===${NC}"

# Check if uv is installed
if ! command -v uv &> /dev/null; then
    echo -e "${YELLOW}uv not found. Installing...${NC}"
    curl -LsSf https://astral.sh/uv/install.sh | sh

    # Add to PATH for this session
    export PATH="$HOME/.local/bin:$PATH"

    if ! command -v uv &> /dev/null; then
        echo -e "${YELLOW}Please add ~/.local/bin to your PATH and re-run this script${NC}"
        exit 1
    fi
fi

echo -e "${GREEN}✓${NC} uv is available"

# Change to dotfiles directory
cd "$DOTFILES_DIR"

# Install dotfiles CLI as a uv tool (globally available)
echo -e "${BLUE}→${NC} Installing dotfiles CLI as uv tool..."
uv tool install --force --editable "$DOTFILES_DIR"
echo -e "${GREEN}✓${NC} dotfiles CLI installed (run 'dotfiles' from anywhere)"

# Ensure uv tools are in PATH
export PATH="$HOME/.local/bin:$PATH"

# Run the dotfiles CLI
echo -e "${BLUE}→${NC} Running dotfiles install..."
dotfiles install "$@"

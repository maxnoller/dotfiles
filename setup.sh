#!/bin/bash
# Bootstrap script - installs uv and runs dotfiles CLI

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${BLUE}=== Dotfiles Bootstrap ===${NC}"

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

echo -e "${GREEN}uv is available${NC}"

# Change to dotfiles directory
cd "$DOTFILES_DIR"

# Run the dotfiles CLI
echo -e "${BLUE}Running dotfiles install...${NC}"
uv run dotfiles install "$@"

#!/bin/bash
# Remote bootstrap script - run with:
# curl -fsSL https://raw.githubusercontent.com/USER/dotfiles/main/scripts/bootstrap.sh | bash
#
# Or with a specific branch:
# curl -fsSL https://raw.githubusercontent.com/USER/dotfiles/main/scripts/bootstrap.sh | bash -s -- --branch dev

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

DOTFILES_REPO="https://github.com/maxnoller/dotfiles.git"
DOTFILES_DIR="$HOME/dotfiles"
BRANCH="main"

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --branch|-b)
            BRANCH="$2"
            shift 2
            ;;
        --dir|-d)
            DOTFILES_DIR="$2"
            shift 2
            ;;
        *)
            shift
            ;;
    esac
done

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║       Dotfiles Bootstrap Script        ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo

# Detect distro
detect_distro() {
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        echo "$ID"
    else
        echo "unknown"
    fi
}

DISTRO=$(detect_distro)
echo -e "${BLUE}→${NC} Detected distro: ${GREEN}$DISTRO${NC}"

# Install prerequisites (git, curl)
install_prereqs() {
    echo -e "${BLUE}→${NC} Installing prerequisites (git, curl)..."

    case $DISTRO in
        arch|manjaro|endeavouros)
            sudo pacman -Sy --needed --noconfirm git curl
            ;;
        ubuntu|debian|pop|linuxmint)
            sudo apt update
            sudo apt install -y git curl
            ;;
        fedora)
            sudo dnf install -y git curl
            ;;
        *)
            echo -e "${YELLOW}⚠ Unknown distro. Please install git and curl manually.${NC}"
            exit 1
            ;;
    esac
}

# Check for git and curl, install if missing
if ! command -v git &> /dev/null || ! command -v curl &> /dev/null; then
    install_prereqs
else
    echo -e "${GREEN}✓${NC} Prerequisites already installed"
fi

# Clone dotfiles repo
if [[ -d "$DOTFILES_DIR" ]]; then
    echo -e "${YELLOW}⚠${NC} $DOTFILES_DIR already exists"
    read -p "Remove and re-clone? [y/N] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf "$DOTFILES_DIR"
    else
        echo -e "${BLUE}→${NC} Using existing directory"
    fi
fi

if [[ ! -d "$DOTFILES_DIR" ]]; then
    echo -e "${BLUE}→${NC} Cloning dotfiles to $DOTFILES_DIR..."
    git clone --branch "$BRANCH" "$DOTFILES_REPO" "$DOTFILES_DIR"
fi

# Run setup
echo -e "${BLUE}→${NC} Running setup..."
cd "$DOTFILES_DIR"
./setup.sh

echo
echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║            Setup Complete!             ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
echo
echo -e "Please restart your shell or run: ${BLUE}source ~/.zshrc${NC}"

#!/bin/bash
# Remote bootstrap script - run with:
# curl -fsSL https://raw.githubusercontent.com/maxnoller/dotfiles/main/scripts/bootstrap.sh | bash
#
# Options:
#   --branch, -b    Git branch to clone (default: main)
#   --dir, -d       Directory to clone to (default: ~/dotfiles)
#   --version, -v   Install specific release version (e.g., v0.1.0)
#   --local, -l     Install CLI from local source instead of GitHub release
#   --no-clone      Skip cloning, just install CLI from release (minimal install)
#
# Examples:
#   # Full install from latest release
#   curl -fsSL https://raw.githubusercontent.com/maxnoller/dotfiles/main/scripts/bootstrap.sh | bash
#
#   # Install specific version
#   curl -fsSL ... | bash -s -- --version v0.1.0
#
#   # Development install from local source
#   curl -fsSL ... | bash -s -- --local

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

GITHUB_REPO="maxnoller/dotfiles"
DOTFILES_REPO="https://github.com/$GITHUB_REPO.git"
DOTFILES_DIR="$HOME/dotfiles"
BRANCH="main"
VERSION=""
INSTALL_LOCAL=false
NO_CLONE=false

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
        --version|-v)
            VERSION="$2"
            shift 2
            ;;
        --local|-l)
            INSTALL_LOCAL=true
            shift
            ;;
        --no-clone)
            NO_CLONE=true
            shift
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
    echo -e "${BLUE}→${NC} Installing prerequisites..."

    local packages="curl"
    [[ "$NO_CLONE" != "true" ]] && packages="git curl"

    case $DISTRO in
        arch|manjaro|endeavouros)
            sudo pacman -Sy --needed --noconfirm $packages
            ;;
        ubuntu|debian|pop|linuxmint)
            sudo apt update
            sudo apt install -y $packages
            ;;
        fedora)
            sudo dnf install -y $packages
            ;;
        *)
            echo -e "${YELLOW}⚠ Unknown distro. Please install $packages manually.${NC}"
            exit 1
            ;;
    esac
}

# Check for required commands
needs_prereqs=false
if ! command -v curl &> /dev/null; then
    needs_prereqs=true
fi
if [[ "$NO_CLONE" != "true" ]] && ! command -v git &> /dev/null; then
    needs_prereqs=true
fi

if [[ "$needs_prereqs" == "true" ]]; then
    install_prereqs
else
    echo -e "${GREEN}✓${NC} Prerequisites already installed"
fi

# Install uv if not available
if ! command -v uv &> /dev/null; then
    echo -e "${BLUE}→${NC} Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.local/bin:$PATH"

    if ! command -v uv &> /dev/null; then
        echo -e "${RED}✗${NC} Failed to install uv. Please add ~/.local/bin to your PATH."
        exit 1
    fi
fi
echo -e "${GREEN}✓${NC} uv is available"

# Clone dotfiles repo (unless --no-clone)
if [[ "$NO_CLONE" != "true" ]]; then
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
fi

# Install dotfiles CLI
if [[ "$INSTALL_LOCAL" == "true" ]]; then
    # Install from local source
    if [[ ! -d "$DOTFILES_DIR" ]]; then
        echo -e "${RED}✗${NC} Cannot use --local without cloning first"
        exit 1
    fi
    echo -e "${BLUE}→${NC} Installing dotfiles CLI from local source..."
    cd "$DOTFILES_DIR"
    uv tool install --force --editable "$DOTFILES_DIR"
else
    # Install from GitHub release
    echo -e "${BLUE}→${NC} Installing dotfiles CLI from GitHub release..."

    if [[ -z "$VERSION" ]]; then
        # Get latest release version
        VERSION=$(curl -fsSL "https://api.github.com/repos/$GITHUB_REPO/releases/latest" 2>/dev/null | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/' || true)
    fi

    if [[ -z "$VERSION" ]]; then
        echo -e "${YELLOW}⚠${NC} No releases found. Falling back to local install..."
        if [[ ! -d "$DOTFILES_DIR" ]]; then
            echo -e "${RED}✗${NC} No release and no local source available"
            exit 1
        fi
        cd "$DOTFILES_DIR"
        uv tool install --force --editable "$DOTFILES_DIR"
    else
        echo -e "${BLUE}→${NC} Installing version: $VERSION"
        RELEASE_URL="https://github.com/$GITHUB_REPO/releases/download/$VERSION"
        uv tool install --force "dotfiles @ ${RELEASE_URL}/dotfiles-${VERSION#v}-py3-none-any.whl"
    fi
fi

echo -e "${GREEN}✓${NC} dotfiles CLI installed"

# Ensure tools are in PATH
export PATH="$HOME/.local/bin:$PATH"

# Run dotfiles install
echo -e "${BLUE}→${NC} Running dotfiles install..."
dotfiles install

echo
echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║            Setup Complete!             ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
echo
echo -e "Please restart your shell or run: ${BLUE}source ~/.zshrc${NC}"

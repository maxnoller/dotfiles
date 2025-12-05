#!/bin/bash
# Bootstrap script - installs uv, installs dotfiles CLI from GitHub release, and runs it
#
# Options:
#   --local    Install from local source (editable mode) instead of GitHub release
#   --version  Install a specific version (e.g., --version v0.1.0)

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GITHUB_REPO="maxnoller/dotfiles"
INSTALL_LOCAL=false
VERSION=""

# Parse arguments
PASSTHROUGH_ARGS=()
while [[ $# -gt 0 ]]; do
    case $1 in
        --local|-l)
            INSTALL_LOCAL=true
            shift
            ;;
        --version|-v)
            VERSION="$2"
            shift 2
            ;;
        *)
            PASSTHROUGH_ARGS+=("$1")
            shift
            ;;
    esac
done

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

# Install dotfiles CLI
if [[ "$INSTALL_LOCAL" == "true" ]]; then
    # Install from local source (editable mode)
    echo -e "${BLUE}→${NC} Installing dotfiles CLI from local source (editable)..."
    cd "$DOTFILES_DIR"
    uv tool install --force --editable "$DOTFILES_DIR"
else
    # Install from GitHub release
    echo -e "${BLUE}→${NC} Installing dotfiles CLI from GitHub release..."

    if [[ -n "$VERSION" ]]; then
        # Install specific version
        RELEASE_URL="https://github.com/$GITHUB_REPO/releases/download/$VERSION"
    else
        # Get latest release version
        LATEST=$(curl -fsSL "https://api.github.com/repos/$GITHUB_REPO/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
        if [[ -z "$LATEST" ]]; then
            echo -e "${YELLOW}⚠ No releases found. Falling back to local install...${NC}"
            cd "$DOTFILES_DIR"
            uv tool install --force --editable "$DOTFILES_DIR"
            INSTALL_LOCAL=true
        else
            VERSION="$LATEST"
            RELEASE_URL="https://github.com/$GITHUB_REPO/releases/download/$VERSION"
        fi
    fi

    if [[ "$INSTALL_LOCAL" != "true" ]]; then
        echo -e "${BLUE}→${NC} Installing version: $VERSION"
        # Install wheel directly from GitHub release
        uv tool install --force "dotfiles @ ${RELEASE_URL}/dotfiles-${VERSION#v}-py3-none-any.whl"
    fi
fi

echo -e "${GREEN}✓${NC} dotfiles CLI installed (run 'dotfiles' from anywhere)"

# Ensure uv tools are in PATH
export PATH="$HOME/.local/bin:$PATH"

# Run the dotfiles CLI
echo -e "${BLUE}→${NC} Running dotfiles install..."
dotfiles install "${PASSTHROUGH_ARGS[@]}"

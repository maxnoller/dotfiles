# CLAUDE.md

This file provides guidance to Claude Code when working with code in this repository.

## Overview

This is a **Nix-based dotfiles** repository that manages a development environment using:

- **Nix Flakes** - Reproducible package management
- **Home Manager** - Declarative home environment configuration
- **Neovim** - Symlinked configuration in `config/nvim/`

## Primary Commands

### Apply Configuration

```bash
# Apply home-manager configuration
home-manager switch --flake .#max

# Update flakes and apply
nix flake update && home-manager switch --flake .#max

# Convenient alias (after initial setup)
hm-update
```

### Development

```bash
# Check flake validity
nix flake check

# Build configuration (dry-run)
nix build .#homeConfigurations.max.activationPackage --dry-run

# Format Nix files
nix run nixpkgs#nixfmt-rfc-style -- *.nix modules/*.nix
```

## Architecture

### Project Structure

```
~/dotfiles/
├── flake.nix                # Nix flake entry point
├── flake.lock               # Locked dependencies
├── home.nix                 # Main home-manager config
├── modules/                 # Home Manager modules
│   ├── zsh.nix              # Zsh + Starship + FZF
│   ├── git.nix              # Git + GitHub CLI
│   ├── tmux.nix             # Tmux + plugins
│   ├── tools.nix            # Developer tools (bun, uv, ripgrep, etc.)
│   ├── claude.nix           # Claude Code settings
│   └── fastfetch.nix        # System info display
├── config/                  # External configurations
│   └── nvim/                # Neovim config (symlinked)
└── .github/workflows/       # CI for flake validation
```

### Modules

| Module | Purpose |
|--------|---------|
| `zsh.nix` | Zsh with Oh My Zsh, Starship prompt, FZF |
| `git.nix` | Git configuration, GitHub CLI |
| `tmux.nix` | Tmux with plugins (vim-navigator, resurrect, continuum) |
| `tools.nix` | Developer tools: bun, uv, pnpm, ripgrep, fd, jq |
| `claude.nix` | Claude Code settings.json |
| `fastfetch.nix` | System info on shell startup |

## Key Technologies

| Tool | Purpose |
|------|---------|
| **Nix Flakes** | Reproducible, declarative package management |
| **Home Manager** | User environment configuration |
| **Starship** | Cross-shell prompt |
| **FZF** | Fuzzy finder with blue theme |

## Important Patterns

- All configuration is **declarative** in `.nix` files
- Run `home-manager switch --flake .#max` to apply changes
- Neovim config is symlinked (not managed by Nix) for flexibility
- Shell aliases, environment variables, and plugins are in `modules/zsh.nix`

## What Gets Installed

Packages managed via `modules/tools.nix`:
- **Developer tools**: bun, uv, pnpm
- **Utilities**: ripgrep, fd, jq, tree, curl

Programs with full configuration:
- **Zsh** with Oh My Zsh, Starship, syntax highlighting
- **Tmux** with vim-tmux-navigator, resurrect, continuum
- **Git** with sensible defaults
- **FZF** with blue/black theme
- **Fastfetch** for system info display

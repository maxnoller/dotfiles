# CLAUDE.md

This file provides guidance to Claude Code when working with code in this repository.

## Overview

This is a **Nix-based dotfiles** repository that manages a development environment using:

- **Nix Flakes** - Reproducible package management
- **Home Manager** - Declarative home environment configuration
- **NixOS** - Full system configuration (optional)
- **Neovim** - Managed via nixCats in `modules/neovim.nix`

## Primary Commands

### Home Manager (Standalone)

```bash
# Apply configuration
home-manager switch --flake .#desktop

# Update flakes and apply
nix flake update && home-manager switch --flake .#desktop
```

### NixOS

```bash
# Build VM for testing
nixos-rebuild build-vm --flake .#desktop-vm
./result/bin/run-nixos-desktop-vm

# Apply to real system
sudo nixos-rebuild switch --flake .#desktop-nixos
```

### Development

```bash
# Check flake validity
nix flake check

# Build configuration (dry-run)
nix build .#homeConfigurations.desktop.activationPackage --dry-run

# Format Nix files
nix run nixpkgs#nixfmt-rfc-style -- *.nix modules/*.nix
```

## Architecture

### Project Structure

```
~/dotfiles/
├── flake.nix                # Nix flake entry point
├── flake.lock               # Locked dependencies
├── home.nix                 # Home Manager config (non-NixOS)
├── home-nixos.nix           # Home Manager config (NixOS)
├── hosts/                   # Host-specific profiles
│   ├── desktop.nix          # Desktop (NVIDIA, GUI apps)
│   └── server.nix           # Server (headless)
├── modules/                 # Home Manager modules
└── nixos/                   # NixOS system configs
    ├── configuration.nix    # Base system
    ├── hardware-vm.nix      # VM testing
    └── hardware-nvidia.nix  # NVIDIA GPU
```

### Modules

| Module | Purpose | Target |
|--------|---------|--------|
| `zsh.nix` | Zsh with Oh My Zsh, Starship prompt, FZF | All |
| `git.nix` | Git configuration, GitHub CLI | All |
| `tmux.nix` | Tmux with plugins (vim-navigator, resurrect, continuum) | All |
| `tools.nix` | Developer tools (bun, uv, pnpm, k8s tools, etc.) | Non-NixOS |
| `tools-nixos.nix` | Developer tools (NixOS variant, no workarounds) | NixOS |
| `claude.nix` | Claude Code settings.json | All |
| `fastfetch.nix` | System info on shell startup | All |
| `neovim.nix` | nixCats-managed Neovim configuration | All |
| `hyprland.nix` | Hyprland window manager + dependencies | NixOS |
| `waybar.nix` | Nord-themed status bar | NixOS |
| `rofi.nix` | Nord-themed app launcher | NixOS |
| `browsers.nix` | Chrome browser | Desktop |
| `gpu.nix` | NVIDIA GPU config for Home Manager | Desktop |

## Key Technologies

| Tool | Purpose |
|------|---------|
| **Nix Flakes** | Reproducible, declarative package management |
| **Home Manager** | User environment configuration |
| **NixOS** | Full system configuration |
| **Hyprland** | Wayland compositor (NixOS desktop) |
| **Starship** | Cross-shell prompt |
| **FZF** | Fuzzy finder with blue theme |

## Important Patterns

- All configuration is **declarative** in `.nix` files
- Run `home-manager switch --flake .#desktop` to apply Home Manager changes
- Run `sudo nixos-rebuild switch --flake .#desktop-nixos` for NixOS changes
- Neovim is managed via **nixCats** in `modules/neovim.nix`
- Shell aliases, environment variables, and plugins are in `modules/zsh.nix`
- Hardware modules are injected via `flake.nix` — **not** imported in `configuration.nix`

## What Gets Installed

Packages managed via `modules/tools.nix` / `tools-nixos.nix`:
- **Developer tools**: bun, nodejs, uv, pnpm, moon, proto
- **DevOps**: kubernetes-helm, kubectl, fluxcd
- **Utilities**: ripgrep, fd, jq, tree, curl
- **Apps**: bitwarden, ghostty, spotify, discord

Programs with full configuration:
- **Zsh** with Oh My Zsh, Starship, syntax highlighting
- **Tmux** with vim-tmux-navigator, resurrect, continuum
- **Git** with sensible defaults
- **FZF** with blue/black theme
- **Fastfetch** for system info display
- **Neovim** via nixCats

NixOS Desktop additions:
- **Hyprland** window manager with Nord theme
- **Waybar** status bar
- **Rofi** app launcher
- **SDDM** display manager
- **PipeWire** audio
- **Steam** + gamemode

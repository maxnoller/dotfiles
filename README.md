# Dotfiles

Declarative development environment using **Nix Flakes** and **Home Manager**.

Supports **standalone Home Manager** (on Debian, Ubuntu, etc.) and **full NixOS** systems.

## Quick Start

### Standalone Home Manager (Debian/Ubuntu)

```bash
# Install Nix (if not already installed)
sh <(curl -L https://nixos.org/nix/install) --daemon

# Clone and apply
git clone https://github.com/maxnoller/dotfiles.git ~/dotfiles
cd ~/dotfiles
home-manager switch --flake .#desktop
```

### NixOS

```bash
# Clone dotfiles
git clone https://github.com/maxnoller/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Build VM for testing
nixos-rebuild build-vm --flake .#desktop-vm
./result/bin/run-nixos-desktop-vm

# Real install (after nixos-generate-config)
sudo nixos-rebuild switch --flake .#desktop-nixos
```

## Configurations

| Flake Output | Target | Description |
|--------------|--------|-------------|
| `homeConfigurations.desktop` | Home Manager | Desktop with NVIDIA GPU, GUI apps |
| `homeConfigurations.server` | Home Manager | Headless server (no GUI) |
| `nixosConfigurations.desktop-vm` | NixOS | VM for testing |
| `nixosConfigurations.desktop-nixos` | NixOS | Real desktop with NVIDIA + Hyprland |

## Commands

```bash
# Apply Home Manager configuration
home-manager switch --flake .#desktop

# Update flakes and apply
nix flake update && home-manager switch --flake .#desktop

# Validate flake
nix flake check

# Format Nix files
nix run nixpkgs#nixfmt-rfc-style -- *.nix **/*.nix
```

## Project Structure

```
dotfiles/
├── flake.nix              # Nix flake entry point
├── flake.lock             # Locked dependencies
├── home.nix               # Shared Home Manager config
├── home-nixos.nix         # Shared Home Manager config for NixOS
├── config/                # App configurations (zsh, tmux, etc.)
├── systems/               # System Configurations
│   ├── home/              # Home Manager systems
│   │   ├── desktop/       # Desktop profile
│   │   └── server/        # Server profile
│   └── nixos/             # NixOS systems
│       └── nixos-desktop/ # Main desktop config
└── modules/               # Reusable modules
    ├── home/              # Home Manager modules
    │   ├── zsh.nix        # Zsh + Starship + FZF
    │   ├── git.nix        # Git + GitHub CLI
    │   ├── tmux.nix       # Tmux + plugins
    │   └── ...
    └── nixos/             # NixOS modules
        ├── hardware-vm.nix
        └── hardware-nvidia.nix
```

## Troubleshooting

### SUID Sandbox Error on Ubuntu 24.04+ (Chrome, Electron apps)

When running Chrome or Electron apps (Bitwarden, VS Code, etc.) installed via Nix/Home Manager on Ubuntu 24.04+, you may see:

```
The SUID sandbox helper binary was found, but is not configured correctly.
```

This happens because Ubuntu 24.04 restricts unprivileged user namespaces via AppArmor.

**Fix:** Create an AppArmor profile for Nix store executables:

```bash
sudo tee /etc/apparmor.d/nix-store << 'EOF'
abi <abi/4.0>,
include <tunables/global>

profile nix-store /nix/store/** flags=(unconfined) {
  userns,
  include if exists <local/nix-store>
}
EOF

sudo apparmor_parser -r /etc/apparmor.d/nix-store
```

## License

MIT

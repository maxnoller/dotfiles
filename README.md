# Dotfiles

Development environment setup CLI built with Python, using uv for package management.

Supports **Ubuntu**, **Debian**, and **Arch Linux**.

## Quick Start

**One-liner** (fresh machine, installs everything):

```bash
curl -fsSL https://raw.githubusercontent.com/maxnoller/dotfiles/main/scripts/bootstrap.sh | bash
```

**Manual** (if you already have git/curl):

```bash
git clone https://github.com/maxnoller/dotfiles.git ~/dotfiles
~/dotfiles/setup.sh
```

### Installation Options

The bootstrap script supports several options:

```bash
# Install a specific version
curl -fsSL ... | bash -s -- --version v0.1.0

# Install from local source (for development)
curl -fsSL ... | bash -s -- --local

# Clone to a custom directory
curl -fsSL ... | bash -s -- --dir ~/my-dotfiles

# Use a specific branch
curl -fsSL ... | bash -s -- --branch dev
```

The `setup.sh` script also supports:

```bash
# Install from local source instead of GitHub release
./setup.sh --local

# Install a specific version
./setup.sh --version v0.1.0
```

By default, the CLI is installed from the latest GitHub release. Use `--local` for development.

## Commands

After setup, `dotfiles` is available globally:

```bash
# Full installation
dotfiles install

# Preview changes without applying
dotfiles install --dry-run

# Update/sync configurations
dotfiles sync

# Check installation status
dotfiles status

# Remove symlinks
dotfiles uninstall

# Remove symlinks and tools
dotfiles uninstall --remove-tools
```

## What Gets Installed

| Component | Source | Description |
|-----------|--------|-------------|
| **System Packages** | apt/pacman | git, zsh, stow, curl, neovim |
| **Oh My Zsh** | installer | Zsh framework with Powerlevel10k theme |
| **Proto** | installer | Multi-language version manager |
| **Node.js** | proto | JavaScript runtime |
| **uv** | proto | Python package manager |
| **gh** | proto | GitHub CLI |
| **TPM** | git | Tmux Plugin Manager |
| **GitHub CLI Extensions** | gh | gh-act |

## Configuration

Configurations are managed via GNU Stow and stored in the `config/` directory:

- `config/nvim/` → `~/.config/nvim`
- `config/tmux/` → `~/.tmux.conf`
- `config/zsh/` → `~/.zshrc`, `~/.p10k.zsh`

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `DOTFILES_GIT_NAME` | Git user name | (prompted) |
| `DOTFILES_GIT_EMAIL` | Git user email | (prompted) |
| `DOTFILES_GIT_WORK_EMAIL` | Git work email | (optional) |
| `DOTFILES_GIT_WORK_REMOTE_PATTERN` | Pattern to match work remotes | (optional) |
| `DOTFILES_NODE_VERSION` | Node.js version | `23` |

## Project Structure

```
dotfiles/
├── src/dotfiles/          # Python CLI source
│   ├── cli.py             # Typer CLI commands
│   ├── config.py          # Pydantic Settings configuration
│   ├── console.py         # Rich console output
│   ├── runner.py          # Subprocess runner
│   └── tasks/             # Task modules
├── config/                # Stow packages (dotfile configs)
│   ├── nvim/
│   ├── tmux/
│   └── zsh/
├── scripts/               # Utility scripts
├── tests/                 # Pytest tests
├── .prototools            # Proto version configuration
├── pyproject.toml         # Project configuration
└── setup.sh               # Bootstrap script
```

## Development

```bash
# Install dev dependencies
uv sync

# Run linter
uv run ruff check src/ tests/

# Run formatter
uv run ruff format src/ tests/

# Run type checker
uv run basedpyright

# Run tests
uv run pytest

# Run tests with coverage
uv run pytest --cov=dotfiles
```

## Troubleshooting

### SUID Sandbox Error on Ubuntu 24.04 (Chrome, Electron apps)

When running Chrome or Electron apps (Bitwarden, VS Code, etc.) installed via Nix/Home Manager on Ubuntu 24.04+, you may see:

```
The SUID sandbox helper binary was found, but is not configured correctly.
```

This happens because Ubuntu 24.04 restricts unprivileged user namespaces via AppArmor, and the default profiles don't cover Nix store paths.

**Fix:** Create an AppArmor profile for all Nix store executables:

```bash
sudo tee /etc/apparmor.d/nix-store << 'EOF'
abi <abi/4.0>,
include <tunables/global>

# Grant userns permission to all Nix store executables
# Fixes Chrome/Electron sandbox issues on Ubuntu 24.04+ with Nix/Home Manager
profile nix-store /nix/store/** flags=(unconfined) {
  userns,
  include if exists <local/nix-store>
}
EOF

sudo apparmor_parser -r /etc/apparmor.d/nix-store
```

This grants all Nix-installed applications permission to use unprivileged user namespaces while maintaining full sandbox security.

## License

MIT

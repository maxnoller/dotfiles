# CLAUDE.md

This file provides guidance to Claude Code when working with code in this repository.

## Overview

This is a **Python-based dotfiles** repository that sets up a development environment. It uses:

- **Python CLI** (`dotfiles`) - Built with Typer, Pydantic, and Rich
- **uv** - Python package manager and runner
- **Proto** - Multi-language version manager (manages Node.js, uv, gh)
- **GNU Stow** - Symlink-based configuration management

## Primary Commands

### Running the CLI

```bash
# Install everything
uv run dotfiles install

# Dry-run (preview without changes)
uv run dotfiles install --dry-run

# Update/sync configurations
uv run dotfiles sync

# Check installation status
uv run dotfiles status

# Uninstall
uv run dotfiles uninstall
uv run dotfiles uninstall --remove-tools  # Also remove oh-my-zsh, proto, etc.
```

### Bootstrap (Fresh System)

```bash
# Run setup script (installs uv if needed, then runs dotfiles install)
./setup.sh
```

### Development

```bash
# Install dev dependencies
uv sync --group dev

# Run linters
uv run ruff check src/
uv run ruff format src/

# Type checking
uv run basedpyright src/

# Run tests
uv run pytest

# Run specific test
uv run pytest tests/test_cli.py -v
```

## Architecture

### Project Structure

```
~/dotfiles/
├── src/dotfiles/           # Python CLI package
│   ├── __init__.py
│   ├── cli.py              # Typer CLI commands
│   ├── config.py           # Pydantic Settings configuration
│   ├── console.py          # Rich console output
│   ├── runner.py           # Subprocess runner with sudo caching
│   └── tasks/              # Installation task modules
│       ├── apt.py          # APT package installation
│       ├── shell.py        # Oh My Zsh, plugins
│       ├── tools.py        # Proto, proto tools, TPM
│       ├── git.py          # Git configuration
│       ├── stow.py         # Stow config deployment
│       └── github.py       # GitHub CLI extensions
├── config/                 # Stow-managed configuration files
│   ├── nvim/               # Neovim configuration
│   ├── tmux/               # Tmux configuration
│   └── zsh/                # Zsh configuration (.zshrc, .p10k.zsh)
├── scripts/                # Utility scripts
├── tests/                  # Pytest tests
├── pyproject.toml          # Project configuration
├── .prototools             # Proto version pins and plugin config
└── setup.sh                # Bootstrap script
```

### Configuration Management

Uses **GNU Stow** for symlink-based configuration. Configs in `config/` are deployed to home:

- `config/nvim/` → `~/.config/nvim`
- `config/tmux/` → `~/.tmux.conf`
- `config/zsh/` → `~/.zshrc`, `~/.p10k.zsh`

### Environment Variables

Git configuration can be set via environment variables (or prompted interactively):

```bash
export DOTFILES_GIT_NAME="Your Name"
export DOTFILES_GIT_EMAIL="your@email.com"
export DOTFILES_GIT_WORK_EMAIL="work@company.com"
export DOTFILES_GIT_WORK_REMOTE_PATTERN="gitlab.company.com*/**"
```

Other configuration:

```bash
export DOTFILES_NODE_VERSION="20"  # Override default Node.js version
```

## Key Technologies

| Tool | Purpose |
|------|---------|
| **Typer** | CLI framework with automatic help generation |
| **Pydantic Settings** | Configuration with environment variable support |
| **Rich** | Terminal output formatting |
| **Proto** | Version management for Node.js, uv, gh (replaces NVM) |
| **GNU Stow** | Symlink farm manager for configs |

## Important Patterns

- All tasks are **idempotent** - safe to run multiple times
- Tasks check existence before installing (skip if already present)
- **Dry-run mode** (`--dry-run`) previews all changes
- **Error handling** with `RunnerError` exception and proper exit codes
- Git configuration is **prompted interactively** (not hardcoded)
- Uses `subprocess` with list arguments to avoid shell injection

## What Gets Installed

1. **APT packages**: git, zsh, stow, curl, neovim
2. **Oh My Zsh** with Powerlevel10k theme and plugins
3. **Proto** toolchain manager
4. **Proto-managed tools**: Node.js, uv, gh (configured in `.prototools`)
5. **TPM** (Tmux Plugin Manager)
6. **Stowed configs**: zsh, tmux, nvim
7. **GitHub CLI extensions**: gh-act

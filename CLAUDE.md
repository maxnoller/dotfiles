# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is an Ansible dotfiles repository that sets up a comprehensive development environment. The main playbook (`site.yml`) orchestrates the installation and configuration of development tools including Git, Zsh, tmux, Node.js, Python UV, Neovim, and GitHub CLI.

## Primary Commands

### Running the Playbook
```bash
# Full setup (requires sudo password)
ansible-playbook site.yml --ask-become-pass

# Quick setup script (handles dependencies)
./setup.sh

# Run specific tool configurations
ansible-playbook site.yml --ask-become-pass --tags neovim
ansible-playbook site.yml --ask-become-pass --tags tools
```

### Development and Testing
```bash
# Linting (used in CI)
ansible-lint

# Run Molecule tests (CI only - requires Docker)
molecule test

# Update local setup
~/.local/bin/update-setup  # (symlinked from scripts/update-setup)
```

## Architecture

### Core Structure
- **`site.yml`** - Main playbook that orchestrates all tasks
- **`tasks/`** - Individual task files for each tool/component
- **`config/`** - Configuration files deployed via GNU Stow
- **`handlers/`** - Ansible handlers for service reloading
- **`scripts/`** - Utility scripts symlinked to `~/.local/bin`

### Task Organization
The repository uses a modular approach with separate task files:
- **`git.yml`** - Git configuration with work/personal profiles
- **`zsh.yml`** - Oh My Zsh with plugins and themes
- **`tmux.yml`** - Tmux with TPM plugin manager
- **`node.yml`** - NVM and Node.js setup
- **`python_uv.yml`** - UV Python package manager
- **`neovim.yml`** - Neovim with PPA and configuration
- **`github.yml`** - GitHub CLI and extensions
- **`local_bin.yml`** - Local binary management

### Configuration Management
Uses **GNU Stow** for symlink-based configuration management. Config files are stored in `config/` subdirectories and deployed to appropriate locations:
- `config/nvim/` → `~/.config/nvim`
- `config/tmux/` → `~/.tmux.conf`
- `config/zsh/` → `~/.zshrc`

## Key Variables
- `dotfiles_dir` - Path to the dotfiles repository
- `nvm_version` - NVM version (default: "0.40.1")
- `node_version` - Node.js version (default: "23")
- `required_packages` - System packages to install

## Important Patterns
- Tasks use idempotent operations with `creates`, `changed_when`, and `when` conditions
- Error handling with `ignore_errors: true` and `failed_when: false` for graceful degradation
- Shell integration primarily targets Zsh (`.zshrc` modifications)
- Repository cloning uses `force: false` to avoid overwriting existing installations
- Configuration deployment uses `stow` command with change detection

## CI/CD
- GitHub Actions workflow in `.github/workflows/ci.yml`
- Runs `ansible-lint` and `molecule test` on changes to playbooks
- Molecule tests use Docker containers for isolated testing
- Only tests critical paths (currently `python_uv.yml` task)

## Development Environment Requirements
- **Python 3** and **pip** (handled by `setup.sh`)
- **Ansible** (installed via pip if missing)
- **sudo access** (for package installation and shell changes)
- **GNU Stow** (installed as system package)
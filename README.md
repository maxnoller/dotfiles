# Max's Dotfiles Ansible Playbook

This repository contains Ansible playbooks and roles to set up a personalized development environment.

## Overview

The main playbook (`site.yml`) orchestrates the setup process, installing necessary system packages, configuring tools, and deploying personal configurations using GNU Stow.

## Features

This playbook configures the following:

**System Packages:**
*   `git`
*   `zsh`
*   `stow`
*   `curl`
*   `neovim` (from PPA)
*   `gh` (GitHub CLI)

**Shell & Environment:**
*   Installs [Oh My Zsh](https://ohmyz.sh/)
*   Sets Zsh as the default shell for the user.
*   Deploys Zsh configuration (`.zshrc`, etc.) via Stow from the `config/zsh` directory.
*   Installs [NVM (Node Version Manager)](https://github.com/nvm-sh/nvm) and Node.js v23.
*   Configures `.zshrc` to source NVM.
*   Installs [uv (Python package manager)](https://github.com/astral-sh/uv) via its standalone installer.

**Development Tools:**
*   Configures global Git settings (`.gitconfig`, `.gitconfig-work`).
*   Installs the `gh-act` extension for the GitHub CLI.
*   Installs [Tmux Plugin Manager (TPM)](https://github.com/tmux-plugins/tpm).
*   Deploys Tmux configuration (`.tmux.conf`, etc.) via Stow from the `config/tmux` directory.
*   Adds the Neovim unstable PPA.
*   Deploys Neovim configuration (`init.lua`, etc.) via Stow from the `config/nvim` directory.

**Directory Structure:**
*   Creates `~/projects` directory.

## Prerequisites

*   **Ansible:** Needs to be installed on the machine where you run the playbook. You can typically install it via pip: `pip install ansible`
*   **Sudo Access:** The playbook requires `sudo` privileges for package installation and some configuration steps (like changing the default shell).

## Usage

1.  Clone the repository:
    ```bash
    git clone <repository-url> dotfiles
    cd dotfiles
    ```
2.  Run the playbook:
    ```bash
    ansible-playbook site.yml --ask-become-pass
    ```
    (The `--ask-become-pass` flag prompts for your sudo password when needed).

    You can also run specific parts using tags:
    ```bash
    # Only setup Neovim
    ansible-playbook site.yml --ask-become-pass --tags neovim

    # Only setup tools (git, zsh, tmux, node, python, uv, neovim, github)
    ansible-playbook site.yml --ask-become-pass --tags tools
    ```

## Testing

This repository uses Molecule for testing the Ansible roles within a Docker container. Tests are automatically run via GitHub Actions on push/pull requests to the `main` branch (see `.github/workflows/ansible-test.yml`). 
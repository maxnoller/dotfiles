# Dotfiles

Development environment setup CLI built with Python, using uv for package management.

## Quick Start

```bash
# Clone and run setup
git clone <repository-url> ~/dotfiles
cd ~/dotfiles
./setup.sh
```

## Commands

```bash
# Full installation
uv run dotfiles install

# Preview changes without applying
uv run dotfiles install --dry-run

# Update/sync configurations
uv run dotfiles sync

# Check installation status
uv run dotfiles status

# Remove symlinks
uv run dotfiles uninstall

# Remove symlinks and tools
uv run dotfiles uninstall --remove-tools
```

## What Gets Installed

| Component | Description |
|-----------|-------------|
| **System Packages** | git, zsh, stow, curl, neovim, gh |
| **Oh My Zsh** | Zsh framework with plugins (zsh-autosuggestions, zsh-syntax-highlighting) |
| **Proto** | Multi-language version manager (manages Node.js) |
| **Node.js** | Via proto (version configured in `.prototools`) |
| **uv** | Python package manager |
| **TPM** | Tmux Plugin Manager |
| **GitHub CLI Extensions** | gh-act |

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

## License

MIT

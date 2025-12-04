"""Shell setup tasks - Oh My Zsh, plugins, default shell."""

import os
import pwd

from dotfiles import console
from dotfiles.config import Config
from dotfiles.runner import Runner

ZSH_PLUGINS = [
    (
        "powerlevel10k",
        "https://github.com/romkatv/powerlevel10k.git",
        "themes/powerlevel10k",
    ),
    (
        "zsh-completions",
        "https://github.com/zsh-users/zsh-completions.git",
        "plugins/zsh-completions",
    ),
    (
        "zsh-autosuggestions",
        "https://github.com/zsh-users/zsh-autosuggestions.git",
        "plugins/zsh-autosuggestions",
    ),
    (
        "zsh-syntax-highlighting",
        "https://github.com/zsh-users/zsh-syntax-highlighting.git",
        "plugins/zsh-syntax-highlighting",
    ),
]


def install_oh_my_zsh(runner: Runner, config: Config) -> None:
    """Install Oh My Zsh if not already present."""
    console.header("Installing Oh My Zsh")

    if config.oh_my_zsh_dir.exists():
        console.skip("Oh My Zsh already installed")
        return

    console.info("Installing Oh My Zsh...")
    install_script = (
        "curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"
        " | sh -s -- --unattended"
    )
    runner.run_shell(install_script)
    console.success("Oh My Zsh installed")


def install_zsh_plugins(runner: Runner, config: Config) -> None:
    """Install Powerlevel10k theme and zsh plugins."""
    console.header("Installing Zsh plugins")

    if not config.oh_my_zsh_dir.exists():
        console.error("Oh My Zsh not installed, skipping plugins")
        return

    for name, repo, subpath in ZSH_PLUGINS:
        dest = config.oh_my_zsh_custom / subpath

        if dest.exists():
            console.skip(f"{name} already installed")
            continue

        console.info(f"Installing {name}...")
        if not config.dry_run:
            dest.parent.mkdir(parents=True, exist_ok=True)
        runner.run(["git", "clone", "--depth=1", repo, str(dest)])
        console.success(f"{name} installed")


def update_zsh_plugins(runner: Runner, config: Config) -> None:
    """Update all zsh plugins by pulling latest changes."""
    console.header("Updating Zsh plugins")

    if not config.oh_my_zsh_custom.exists():
        console.skip("No custom plugins directory")
        return

    # Update plugins
    plugins_dir = config.oh_my_zsh_custom / "plugins"
    if plugins_dir.exists():
        for plugin_dir in plugins_dir.iterdir():
            if plugin_dir.is_dir() and (plugin_dir / ".git").exists():
                console.info(f"Updating {plugin_dir.name}...")
                runner.run(
                    ["git", "-C", str(plugin_dir), "pull", "--rebase"],
                    check=False,
                )

    # Update themes (powerlevel10k)
    themes_dir = config.oh_my_zsh_custom / "themes"
    if themes_dir.exists():
        for theme_dir in themes_dir.iterdir():
            if theme_dir.is_dir() and (theme_dir / ".git").exists():
                console.info(f"Updating {theme_dir.name}...")
                runner.run(
                    ["git", "-C", str(theme_dir), "pull", "--rebase"],
                    check=False,
                )

    console.success("Zsh plugins updated")


def set_default_shell(runner: Runner, _config: Config) -> None:
    """Set zsh as the default shell."""
    console.header("Setting default shell")

    current_shell = pwd.getpwuid(os.getuid()).pw_shell

    if current_shell.endswith("zsh"):
        console.skip("Zsh is already the default shell")
        return

    console.info("Setting zsh as default shell...")
    runner.run(["chsh", "-s", "/bin/zsh"], sudo=True)
    console.success("Default shell set to zsh")

"""Dotfiles CLI - install, sync, and manage development environment."""

import logging
import os
import shutil
import sys
from typing import Annotated

import typer
from rich.table import Table

from dotfiles import __version__, console
from dotfiles.config import Config
from dotfiles.runner import Runner, RunnerError
from dotfiles.tasks import (
    install_claude_code,
    install_gh_extensions,
    install_oh_my_zsh,
    install_proto,
    install_proto_tools,
    install_system_packages,
    install_tpm,
    install_zsh_plugins,
    set_default_shell,
    setup_claude_mcp_servers,
    setup_claude_skills,
    setup_directories,
    setup_git_config,
    setup_local_bin,
    stow_configs,
    unstow_configs,
    update_claude_code,
    update_tpm,
    update_zsh_plugins,
)

app = typer.Typer(
    name="dotfiles",
    help="Development environment setup CLI",
    add_completion=True,
    no_args_is_help=True,
)


def version_callback(value: bool) -> None:
    """Print version and exit."""
    if value:
        console.console.print(f"dotfiles version {__version__}")
        raise typer.Exit()


@app.callback()
def main(
    version: Annotated[
        bool | None,
        typer.Option(
            "--version",
            "-V",
            callback=version_callback,
            is_eager=True,
            help="Show version and exit",
        ),
    ] = None,
) -> None:
    """Dotfiles - Development environment setup CLI."""


@app.command()
def install(
    dry_run: Annotated[
        bool,
        typer.Option("--dry-run", "-n", help="Show what would be done without making changes"),
    ] = False,
    verbose: Annotated[
        bool,
        typer.Option("--verbose", "-v", help="Enable verbose output"),
    ] = False,
) -> None:
    """Full installation of packages, tools, and configurations."""
    if verbose:
        logging.basicConfig(level=logging.INFO)

    config = Config(dry_run=dry_run, verbose=verbose)
    runner = Runner(dry_run=dry_run, verbose=verbose)

    if dry_run:
        console.header("=== DRY RUN MODE ===")

    console.header("=== Dotfiles Installation ===")

    try:
        # Phase 1: System packages
        console.header("--- Phase 1: System Packages ---")
        console.info(f"Detected distro: {config.distro.value}")
        install_system_packages(runner, config)

        # Phase 2: Tools
        console.header("--- Phase 2: Tools ---")
        install_oh_my_zsh(runner, config)
        install_proto(runner, config)
        install_proto_tools(runner, config)  # node, uv, gh via proto
        install_zsh_plugins(runner, config)
        install_tpm(runner, config)
        install_claude_code(runner, config)
        setup_claude_mcp_servers(runner, config)
        setup_claude_skills(runner, config)

        # Phase 3: Configuration
        console.header("--- Phase 3: Configuration ---")
        setup_directories(runner, config)
        setup_git_config(runner, config)
        stow_configs(runner, config)
        setup_local_bin(runner, config)

        # Phase 4: Final setup
        console.header("--- Phase 4: Final Setup ---")
        set_default_shell(runner, config)
        install_gh_extensions(runner, config)

        console.header("=== Installation Complete! ===")
        console.console.print("\nPlease restart your shell or run: [bold]source ~/.zshrc[/bold]")

    except RunnerError as e:
        console.error(f"Installation failed: {e}")
        if e.stderr:
            console.console.print(f"[dim]{e.stderr}[/dim]")
        raise typer.Exit(1) from None
    except KeyboardInterrupt:
        console.warning("\nInstallation interrupted")
        raise typer.Exit(130) from None


@app.command()
def sync(
    dry_run: Annotated[
        bool,
        typer.Option("--dry-run", "-n", help="Show what would be done without making changes"),
    ] = False,
    verbose: Annotated[
        bool,
        typer.Option("--verbose", "-v", help="Enable verbose output"),
    ] = False,
) -> None:
    """Update dotfiles and re-apply configurations."""
    if verbose:
        logging.basicConfig(level=logging.INFO)

    config = Config(dry_run=dry_run, verbose=verbose)
    runner = Runner(dry_run=dry_run, verbose=verbose)

    if dry_run:
        console.header("=== DRY RUN MODE ===")

    console.header("=== Syncing Dotfiles ===")

    try:
        # Pull latest changes
        console.info("Pulling latest changes...")
        runner.run(
            ["git", "-C", str(config.dotfiles_dir), "pull", "--rebase"],
            check=False,
        )

        # Re-apply configs
        stow_configs(runner, config)

        # Update plugins and tools
        update_zsh_plugins(runner, config)
        update_tpm(runner, config)
        update_claude_code(runner, config)

        console.header("=== Sync Complete! ===")

    except RunnerError as e:
        console.error(f"Sync failed: {e}")
        raise typer.Exit(1) from None
    except KeyboardInterrupt:
        console.warning("\nSync interrupted")
        raise typer.Exit(130) from None


@app.command()
def uninstall(
    remove_tools: Annotated[
        bool,
        typer.Option("--remove-tools", help="Also remove installed tools (oh-my-zsh, proto, tpm)"),
    ] = False,
    dry_run: Annotated[
        bool,
        typer.Option("--dry-run", "-n", help="Show what would be done without making changes"),
    ] = False,
    force: Annotated[
        bool,
        typer.Option("--force", "-f", help="Skip confirmation prompt"),
    ] = False,
) -> None:
    """Remove symlinks and optionally installed tools."""
    if not force:
        confirmed = typer.confirm("Are you sure you want to uninstall?")
        if not confirmed:
            raise typer.Abort()

    config = Config(dry_run=dry_run)
    runner = Runner(dry_run=dry_run)

    if dry_run:
        console.header("=== DRY RUN MODE ===")

    console.header("=== Uninstalling Dotfiles ===")

    # Unstow configurations
    unstow_configs(runner, config)

    # Remove local bin symlinks
    update_setup_link = config.local_bin / "update-setup"
    if update_setup_link.is_symlink():
        console.info("Removing update-setup symlink...")
        if not dry_run:
            update_setup_link.unlink()
        console.success("update-setup symlink removed")

    if remove_tools:
        console.header("Removing installed tools")

        # Oh My Zsh
        if config.oh_my_zsh_dir.exists():
            console.info("Removing Oh My Zsh...")
            if not dry_run:
                shutil.rmtree(config.oh_my_zsh_dir)
            console.success("Oh My Zsh removed")

        # Proto
        if config.proto_home.exists():
            console.info("Removing proto...")
            if not dry_run:
                shutil.rmtree(config.proto_home)
            console.success("proto removed")

        # TPM
        tpm_dir = config.home / ".tmux" / "plugins" / "tpm"
        if tpm_dir.exists():
            console.info("Removing TPM...")
            if not dry_run:
                shutil.rmtree(tpm_dir)
            console.success("TPM removed")

    console.header("=== Uninstall Complete! ===")


@app.command()
def status() -> None:
    """Show installation status of all components."""
    config = Config()
    runner = Runner()

    console.header("=== Dotfiles Status ===")

    table = Table(show_header=True, header_style="bold")
    table.add_column("Component", style="cyan")
    table.add_column("Status")
    table.add_column("Path/Info", style="dim")

    # Check each component
    checks = [
        ("Oh My Zsh", config.oh_my_zsh_dir.exists(), str(config.oh_my_zsh_dir)),
        ("Powerlevel10k", (config.oh_my_zsh_custom / "themes/powerlevel10k").exists(), ""),
        ("Proto", config.proto_home.exists(), str(config.proto_home)),
        ("uv", runner.command_exists("uv"), ""),
        ("TPM", (config.home / ".tmux/plugins/tpm").exists(), ""),
        ("Bun", runner.command_exists("bun"), ""),
        ("GitHub CLI", runner.command_exists("gh"), ""),
        ("Claude Code", runner.command_exists("claude"), ""),
        ("Neovim", runner.command_exists("nvim"), ""),
        ("Zsh", runner.command_exists("zsh"), ""),
        ("Stow", runner.command_exists("stow"), ""),
    ]

    # Check stowed configs
    stow_checks = [
        (".zshrc", (config.home / ".zshrc").is_symlink()),
        (".tmux.conf", (config.home / ".tmux.conf").is_symlink()),
        (".config/nvim", (config.home / ".config/nvim").is_symlink()),
        (".claude", (config.home / ".claude").is_symlink()),
    ]

    for name, installed, info in checks:
        status_str = "[green]Installed[/green]" if installed else "[red]Missing[/red]"
        table.add_row(name, status_str, info)

    table.add_row("", "", "")  # Separator
    table.add_row("[bold]Stowed Configs[/bold]", "", "")

    for name, is_symlink in stow_checks:
        status_str = "[green]Linked[/green]" if is_symlink else "[yellow]Not linked[/yellow]"
        table.add_row(f"  {name}", status_str, "")

    console.console.print(table)

    # Show current shell
    current_shell = os.environ.get("SHELL", "unknown")
    console.console.print(f"\n[bold]Current shell:[/bold] {current_shell}")

    # Show Python version
    console.console.print(f"[bold]Python:[/bold] {sys.version.split()[0]}")


if __name__ == "__main__":
    app()

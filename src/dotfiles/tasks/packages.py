"""System package installation tasks - supports multiple distros."""

from pathlib import Path

from dotfiles import console
from dotfiles.config import Config
from dotfiles.runner import Runner

# Common packages (same name on both distros)
# gh is installed via proto
COMMON_PACKAGES = ["git", "zsh", "stow", "curl", "neovim"]

# Arch-specific packages (if names differ)
ARCH_PACKAGES = [*COMMON_PACKAGES, "base-devel"]

# Ubuntu/Debian-specific packages
DEBIAN_PACKAGES = COMMON_PACKAGES


def install_system_packages(runner: Runner, config: Config) -> None:
    """Install system packages using the appropriate package manager."""
    if config.is_arch:
        _install_pacman_packages(runner, config)
    elif config.is_debian_based:
        _install_apt_packages(runner, config)
    else:
        console.warning(f"Unsupported distro: {config.distro.value}")
        console.info("Please install manually: " + ", ".join(COMMON_PACKAGES))


def _install_pacman_packages(runner: Runner, _config: Config) -> None:
    """Install packages on Arch Linux using pacman."""
    console.header("Installing packages (pacman)")

    # Update package database
    console.info("Updating pacman database...")
    runner.run(["pacman", "-Sy"], sudo=True, check=False)

    # Install packages
    console.info(f"Installing packages: {', '.join(ARCH_PACKAGES)}")
    runner.run(
        ["pacman", "-S", "--needed", "--noconfirm", *ARCH_PACKAGES],
        sudo=True,
    )
    console.success("Packages installed")


def _install_apt_packages(runner: Runner, _config: Config) -> None:
    """Install packages on Ubuntu/Debian using apt."""
    console.header("Installing packages (apt)")

    # Update apt cache
    console.info("Updating apt cache...")
    runner.run(["apt", "update"], sudo=True, check=False)

    # Add Neovim unstable PPA if not present (Ubuntu only)
    ppa_dir = Path("/etc/apt/sources.list.d")
    ppa_exists = any(ppa_dir.glob("neovim-ppa*")) if ppa_dir.exists() else False

    if not ppa_exists:
        console.info("Adding Neovim unstable PPA...")
        runner.run(
            ["add-apt-repository", "-y", "ppa:neovim-ppa/unstable"],
            sudo=True,
        )
        runner.run(["apt", "update"], sudo=True, check=False)
    else:
        console.skip("Neovim PPA already added")

    # Install packages
    console.info(f"Installing packages: {', '.join(DEBIAN_PACKAGES)}")
    runner.run(["apt", "install", "-y", *DEBIAN_PACKAGES], sudo=True)
    console.success("Packages installed")

"""APT package installation tasks."""

from pathlib import Path

from dotfiles import console
from dotfiles.config import Config
from dotfiles.runner import Runner

# gh is now installed via proto
PACKAGES = ["git", "zsh", "stow", "curl", "neovim"]


def install_apt_packages(runner: Runner, _config: Config) -> None:
    """Install required APT packages including neovim from unstable PPA."""
    console.header("Installing APT packages")

    # Update apt cache
    console.info("Updating apt cache...")
    runner.run(["apt", "update"], sudo=True, check=False)

    # Add Neovim unstable PPA if not present
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
    console.info(f"Installing packages: {', '.join(PACKAGES)}")
    runner.run(["apt", "install", "-y", *PACKAGES], sudo=True)
    console.success("APT packages installed")

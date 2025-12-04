"""GitHub CLI extension tasks."""

from dotfiles import console
from dotfiles.config import Config
from dotfiles.runner import Runner


def install_gh_extensions(runner: Runner, _config: Config) -> None:
    """Install GitHub CLI extensions."""
    console.header("Installing GitHub CLI extensions")

    if not runner.command_exists("gh"):
        console.skip("GitHub CLI not installed, skipping extensions")
        return

    # Check if extension is installed
    result = runner.run(["gh", "extension", "list"], capture=True, check=False)

    if "nektos/gh-act" in result.stdout:
        console.skip("gh-act extension already installed")
        return

    console.info("Installing gh-act extension...")
    result = runner.run(
        ["gh", "extension", "install", "nektos/gh-act"],
        check=False,
    )

    if result.returncode == 0:
        console.success("gh-act extension installed")
    else:
        console.warning("Failed to install gh-act (may need gh auth login first)")

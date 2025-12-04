"""Tool installation tasks - proto, uv, TPM."""

from dotfiles import console
from dotfiles.config import Config
from dotfiles.runner import Runner


def install_proto(runner: Runner, config: Config) -> None:
    """Install proto toolchain manager."""
    console.header("Installing proto")

    proto_bin = config.proto_home / "bin" / "proto"

    if proto_bin.exists():
        console.skip("Proto already installed")
        return

    console.info("Installing proto toolchain manager...")
    runner.run_shell(
        "curl -fsSL https://moonrepo.dev/install/proto.sh | bash -s -- --yes"
    )
    console.success("Proto installed")


def install_uv(runner: Runner, config: Config) -> None:
    """Install uv Python package manager."""
    console.header("Installing uv")

    # Check both possible locations
    uv_local = config.local_bin / "uv"
    uv_cargo = config.home / ".cargo" / "bin" / "uv"

    if uv_local.exists() or uv_cargo.exists() or runner.command_exists("uv"):
        console.skip("uv already installed")
        return

    console.info("Installing uv...")
    runner.run_shell("curl -LsSf https://astral.sh/uv/install.sh | sh")
    console.success("uv installed")


def install_tpm(runner: Runner, config: Config) -> None:
    """Install Tmux Plugin Manager."""
    console.header("Installing TPM")

    tpm_dir = config.home / ".tmux" / "plugins" / "tpm"

    if tpm_dir.exists():
        console.skip("TPM already installed")
        return

    console.info("Installing TPM...")
    if not config.dry_run:
        tpm_dir.parent.mkdir(parents=True, exist_ok=True)
    runner.run(
        ["git", "clone", "https://github.com/tmux-plugins/tpm.git", str(tpm_dir)]
    )
    console.success("TPM installed")


def update_tpm(runner: Runner, config: Config) -> None:
    """Update TPM by pulling latest changes."""
    tpm_dir = config.home / ".tmux" / "plugins" / "tpm"

    if not tpm_dir.exists():
        console.skip("TPM not installed")
        return

    console.info("Updating TPM...")
    runner.run(["git", "-C", str(tpm_dir), "pull", "--rebase"], check=False)
    console.success("TPM updated")

"""Tool installation tasks - proto, uv, gh, TPM."""

from dotfiles import console
from dotfiles.config import Config
from dotfiles.runner import Runner

# Tools to install via proto (defined in .prototools)
PROTO_TOOLS = ["bun", "pnpm", "uv", "gh"]


def install_proto(runner: Runner, config: Config) -> None:
    """Install proto toolchain manager."""
    console.header("Installing proto")

    proto_bin = config.proto_home / "bin" / "proto"

    if proto_bin.exists():
        console.skip("Proto already installed")
        return

    console.info("Installing proto toolchain manager...")
    runner.run_shell("curl -fsSL https://moonrepo.dev/install/proto.sh | bash -s -- --yes")
    console.success("Proto installed")


def install_proto_tools(runner: Runner, config: Config) -> None:
    """Install tools managed by proto (bun, pnpm, uv, gh)."""
    console.header("Installing proto-managed tools")

    proto_bin = config.proto_home / "bin" / "proto"

    if not proto_bin.exists():
        console.error("Proto not installed, skipping tools")
        return

    for tool in PROTO_TOOLS:
        console.info(f"Installing {tool} via proto...")
        # proto install reads version from .prototools
        result = runner.run(
            [str(proto_bin), "install", tool],
            check=False,
        )
        if result.returncode == 0:
            console.success(f"{tool} installed")
        else:
            console.warning(f"Failed to install {tool}")


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
    runner.run(["git", "clone", "https://github.com/tmux-plugins/tpm.git", str(tpm_dir)])
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

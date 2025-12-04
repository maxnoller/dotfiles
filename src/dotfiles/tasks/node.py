"""Node.js installation via proto."""

from dotfiles import console
from dotfiles.config import Config
from dotfiles.runner import Runner


def install_node(runner: Runner, config: Config) -> None:
    """Install Node.js using proto."""
    console.header("Installing Node.js")

    proto_bin = config.proto_home / "bin" / "proto"

    if not proto_bin.exists():
        console.error("Proto not installed, cannot install Node.js")
        return

    # Check if Node.js is already installed via proto
    result = runner.run(
        [str(proto_bin), "list", "node"],
        capture=True,
        check=False,
    )

    if config.node_version in result.stdout:
        console.skip(f"Node.js {config.node_version} already installed via proto")
        return

    console.info(f"Installing Node.js {config.node_version} via proto...")
    runner.run([str(proto_bin), "install", "node", config.node_version])

    console.info(f"Pinning Node.js {config.node_version} globally...")
    runner.run([str(proto_bin), "pin", "--global", "node", config.node_version])

    console.success(f"Node.js {config.node_version} installed via proto")

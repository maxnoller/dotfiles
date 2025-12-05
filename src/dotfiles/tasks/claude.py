"""Claude Code installation tasks."""

from dotfiles import console
from dotfiles.config import Config
from dotfiles.runner import Runner

# MCP servers to configure (name, transport, url_or_command)
MCP_SERVERS = [
    ("context7", "http", "https://mcp.context7.com/mcp"),
    ("sentry", "http", "https://mcp.sentry.dev/mcp"),
    ("playwright", "stdio", "npx @playwright/mcp@latest --headless"),
]

# Skills marketplace and individual skills to install
SKILLS_MARKETPLACE = "anthropics/skills"
SKILLS = ["frontend-design", "webapp-testing"]


def install_claude_code(runner: Runner, config: Config) -> None:
    """Install Claude Code CLI."""
    console.header("Installing Claude Code")

    # Check if already installed
    if runner.command_exists("claude"):
        console.skip("Claude Code already installed")
        return

    console.info("Installing Claude Code via bun...")

    # Use proto's bun to install globally
    proto_bin = config.proto_home / "bin" / "proto"
    if not proto_bin.exists():
        console.error("Proto not installed, cannot install Claude Code")
        return

    # Get bun path from proto
    result = runner.run(
        [str(proto_bin), "bin", "bun"],
        check=False,
        capture=True,
    )

    if result.returncode != 0:
        console.error("Could not find bun via proto")
        return

    bun_bin = result.stdout.strip()
    if not bun_bin:
        console.error("bun path is empty")
        return

    # Install Claude Code globally
    result = runner.run(
        [bun_bin, "install", "-g", "@anthropic-ai/claude-code"],
        check=False,
    )

    if result.returncode == 0:
        console.success("Claude Code installed")
    else:
        console.warning("Failed to install Claude Code")


def update_claude_code(runner: Runner, config: Config) -> None:
    """Update Claude Code to latest version."""
    if not runner.command_exists("claude"):
        console.skip("Claude Code not installed")
        return

    console.info("Updating Claude Code...")

    proto_bin = config.proto_home / "bin" / "proto"
    if not proto_bin.exists():
        console.error("Proto not installed")
        return

    result = runner.run(
        [str(proto_bin), "bin", "bun"],
        check=False,
        capture=True,
    )

    if result.returncode != 0:
        console.error("Could not find bun via proto")
        return

    bun_bin = result.stdout.strip()
    if not bun_bin:
        console.error("bun path is empty")
        return

    result = runner.run(
        [bun_bin, "update", "-g", "@anthropic-ai/claude-code"],
        check=False,
    )

    if result.returncode == 0:
        console.success("Claude Code updated")
    else:
        console.warning("Failed to update Claude Code")


def setup_claude_mcp_servers(runner: Runner, _config: Config) -> None:
    """Configure MCP servers for Claude Code."""
    console.header("Configuring Claude Code MCP servers")

    if not runner.command_exists("claude"):
        console.skip("Claude Code not installed")
        return

    for name, transport, url_or_cmd in MCP_SERVERS:
        console.info(f"Adding MCP server: {name}...")

        if transport == "http":
            cmd = [
                "claude",
                "mcp",
                "add",
                "--transport",
                "http",
                "--scope",
                "user",
                name,
                url_or_cmd,
            ]
        else:
            # stdio transport - split command into args
            parts = url_or_cmd.split()
            cmd = [
                "claude",
                "mcp",
                "add",
                "--transport",
                "stdio",
                "--scope",
                "user",
                name,
                "--",
                *parts,
            ]

        result = runner.run(cmd, check=False)

        if result.returncode == 0:
            console.success(f"{name} MCP server configured")
        else:
            # May already exist, which is fine
            console.skip(f"{name} MCP server already configured or failed")


def setup_claude_skills(runner: Runner, _config: Config) -> None:
    """Install skills from Anthropic marketplace."""
    console.header("Installing Claude Code skills")

    if not runner.command_exists("claude"):
        console.skip("Claude Code not installed")
        return

    # Add the Anthropic skills marketplace
    console.info(f"Adding marketplace: {SKILLS_MARKETPLACE}...")
    result = runner.run(
        ["claude", "plugin", "marketplace", "add", SKILLS_MARKETPLACE],
        check=False,
    )

    if result.returncode == 0:
        console.success("Anthropic skills marketplace added")
    else:
        console.skip("Marketplace already added or failed")

    # Install individual skills
    for skill in SKILLS:
        console.info(f"Installing skill: {skill}...")
        result = runner.run(
            ["claude", "plugin", "install", f"{skill}@anthropic-agent-skills"],
            check=False,
        )

        if result.returncode == 0:
            console.success(f"{skill} installed")
        else:
            console.skip(f"{skill} already installed or failed")

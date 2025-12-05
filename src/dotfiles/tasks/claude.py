"""Claude Code installation tasks."""

import json
import shutil

from dotfiles import console
from dotfiles.config import Config
from dotfiles.runner import Runner

# MCP servers to configure (name, transport, url_or_command)
MCP_SERVERS = [
    ("context7", "http", "https://mcp.context7.com/mcp"),
    ("sentry", "http", "https://mcp.sentry.dev/mcp"),
    ("playwright", "stdio", "npx @playwright/mcp@latest --headless"),
]

# Skills marketplace and plugin bundles to install
SKILLS_MARKETPLACE = "anthropics/skills"
SKILL_PLUGINS = ["example-skills"]  # Includes frontend-design, webapp-testing, etc.

# Default settings for new installations
DEFAULT_SETTINGS = {
    "includeCoAuthoredBy": False,
    "permissions": {
        "allow": [
            "WebSearch",
            "WebFetch",
            "mcp__context7__resolve-library-id",
            "mcp__context7__get-library-docs",
        ],
    },
}


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

    # Install skill plugin bundles
    for plugin in SKILL_PLUGINS:
        console.info(f"Installing plugin: {plugin}...")
        result = runner.run(
            ["claude", "plugin", "install", f"{plugin}@anthropic-agent-skills"],
            check=False,
        )

        if result.returncode == 0:
            console.success(f"{plugin} installed")
        else:
            console.skip(f"{plugin} already installed or failed")


def setup_claude_settings(_runner: Runner, config: Config) -> None:
    """Write default Claude Code settings if none exist."""
    console.header("Configuring Claude Code settings")

    settings_file = config.home / ".claude" / "settings.json"

    if settings_file.exists():
        console.skip("Claude Code settings already exist")
        return

    console.info("Writing default Claude Code settings...")

    if config.dry_run:
        console.info(f"[DRY-RUN] Would write settings to {settings_file}")
        console.success("Claude Code settings configured")
        return

    # Ensure directory exists
    settings_file.parent.mkdir(parents=True, exist_ok=True)

    # Write default settings
    settings_file.write_text(json.dumps(DEFAULT_SETTINGS, indent=2) + "\n")
    console.success("Claude Code settings configured")


def install_custom_skills(_runner: Runner, config: Config) -> None:
    """Install custom skills from dotfiles repo."""
    console.header("Installing custom Claude Code skills")

    source_dir = config.dotfiles_dir / "config" / "claude" / ".claude" / "skills"
    target_dir = config.home / ".claude" / "skills"

    if not source_dir.exists():
        console.skip("No custom skills found")
        return

    for skill_dir in source_dir.iterdir():
        if not skill_dir.is_dir():
            continue

        skill_name = skill_dir.name
        target_skill_dir = target_dir / skill_name

        if target_skill_dir.exists():
            console.skip(f"{skill_name} skill already installed")
            continue

        console.info(f"Installing custom skill: {skill_name}...")

        if config.dry_run:
            console.info(f"[DRY-RUN] Would copy {skill_dir} to {target_skill_dir}")
            console.success(f"{skill_name} installed")
            continue

        target_dir.mkdir(parents=True, exist_ok=True)
        shutil.copytree(skill_dir, target_skill_dir)
        console.success(f"{skill_name} installed")

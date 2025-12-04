"""Git configuration tasks."""

import typer

from dotfiles import console
from dotfiles.config import Config
from dotfiles.runner import Runner

GITCONFIG_TEMPLATE = """\
[init]
    defaultBranch = main

[user]
    name = {name}
    email = {email}
{work_include}
"""

GITCONFIG_WORK_INCLUDE = """\
[includeIf "hasconfig:remote.*.url:{work_pattern}"]
    path = ~/.gitconfig-work
"""

GITCONFIG_WORK_TEMPLATE = """\
[user]
    email = {work_email}
"""


def _prompt_git_config(config: Config) -> tuple[str, str, str, str]:
    """Prompt for git configuration if not set via environment."""
    name = config.git.name
    email = config.git.email
    work_email = config.git.work_email
    work_pattern = config.git.work_remote_pattern

    if not name:
        name = typer.prompt("Git user name", default="")
    if not email:
        email = typer.prompt("Git user email", default="")

    # Work config is optional
    if not work_email and typer.confirm("Configure work git profile?", default=False):
        work_email = typer.prompt("Work email", default="")
        work_pattern = typer.prompt(
            "Work remote pattern (e.g., gitlab.company.com*/**)",
            default="",
        )

    return name, email, work_email, work_pattern


def setup_git_config(_runner: Runner, config: Config) -> None:
    """Create git configuration files."""
    console.header("Setting up Git config")

    gitconfig = config.home / ".gitconfig"
    gitconfig_work = config.home / ".gitconfig-work"

    # Check if already configured
    if gitconfig.exists():
        console.skip(".gitconfig already exists")
        return

    # Get configuration (from env or prompt)
    if config.dry_run:
        console.info("Would prompt for git configuration")
        name, email, work_email, work_pattern = "User", "user@example.com", "", ""
    else:
        name, email, work_email, work_pattern = _prompt_git_config(config)

    if not name or not email:
        console.warning("Git name/email not provided, skipping .gitconfig creation")
        return

    # Build work include section
    work_include = ""
    if work_email and work_pattern:
        work_include = GITCONFIG_WORK_INCLUDE.format(work_pattern=work_pattern)

    # Create main gitconfig
    console.info("Creating .gitconfig...")
    if not config.dry_run:
        content = GITCONFIG_TEMPLATE.format(
            name=name,
            email=email,
            work_include=work_include,
        )
        gitconfig.write_text(content)
        gitconfig.chmod(0o600)
    console.success(".gitconfig created")

    # Create work gitconfig if configured
    if work_email and not gitconfig_work.exists():
        console.info("Creating .gitconfig-work...")
        if not config.dry_run:
            content = GITCONFIG_WORK_TEMPLATE.format(work_email=work_email)
            gitconfig_work.write_text(content)
            gitconfig_work.chmod(0o600)
        console.success(".gitconfig-work created")

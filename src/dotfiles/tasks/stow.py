"""GNU Stow configuration deployment tasks."""

from dotfiles import console
from dotfiles.config import Config
from dotfiles.runner import Runner

STOW_PACKAGES = ["zsh", "tmux", "nvim"]


def setup_directories(_runner: Runner, config: Config) -> None:
    """Create required directories."""
    console.header("Setting up directories")

    dirs = [
        config.home / "projects",
        config.local_bin,
    ]

    for dir_path in dirs:
        if dir_path.exists():
            console.skip(f"{dir_path} already exists")
        else:
            console.info(f"Creating {dir_path}...")
            if not config.dry_run:
                dir_path.mkdir(parents=True, exist_ok=True)
            console.success(f"{dir_path} created")


def stow_configs(runner: Runner, config: Config) -> None:
    """Deploy configuration files using GNU Stow."""
    console.header("Deploying configurations with Stow")

    for package in STOW_PACKAGES:
        package_dir = config.config_dir / package

        if not package_dir.exists():
            console.skip(f"Stow package '{package}' not found")
            continue

        # Handle existing non-symlink files that would conflict
        if package == "zsh":
            zshrc = config.home / ".zshrc"
            if zshrc.exists() and not zshrc.is_symlink():
                console.info("Removing existing .zshrc (non-symlink, created by Oh My Zsh)")
                if not config.dry_run:
                    zshrc.unlink()

        console.info(f"Stowing {package} configuration...")
        runner.run(
            [
                "stow",
                "-t",
                str(config.home),
                "-d",
                str(config.config_dir),
                "--restow",
                package,
            ]
        )
        console.success(f"{package} configuration deployed")


def unstow_configs(runner: Runner, config: Config) -> None:
    """Remove stowed configuration symlinks."""
    console.header("Removing stowed configurations")

    for package in STOW_PACKAGES:
        package_dir = config.config_dir / package

        if not package_dir.exists():
            continue

        console.info(f"Unstowing {package}...")
        runner.run(
            [
                "stow",
                "-D",
                "-t",
                str(config.home),
                "-d",
                str(config.config_dir),
                package,
            ],
            check=False,
        )
        console.success(f"{package} unstowed")


def setup_local_bin(_runner: Runner, config: Config) -> None:
    """Symlink scripts to ~/.local/bin."""
    console.header("Setting up local bin scripts")

    scripts = [
        ("update-setup", config.scripts_dir / "update-setup"),
    ]

    for name, source in scripts:
        dest = config.local_bin / name

        if dest.exists() or dest.is_symlink():
            console.skip(f"{name} symlink already exists")
            continue

        if not source.exists():
            console.error(f"Source script {source} not found")
            continue

        console.info(f"Symlinking {name}...")
        if not config.dry_run:
            dest.symlink_to(source)
        console.success(f"{name} symlinked to {source}")

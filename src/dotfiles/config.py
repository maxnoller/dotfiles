"""Configuration using Pydantic Settings."""

import platform
from enum import Enum
from pathlib import Path
from typing import Annotated

from pydantic import Field, computed_field
from pydantic_settings import BaseSettings, SettingsConfigDict


class Distro(Enum):
    """Supported Linux distributions."""

    ARCH = "arch"
    UBUNTU = "ubuntu"
    DEBIAN = "debian"
    UNKNOWN = "unknown"


def detect_distro() -> Distro:
    """Detect the current Linux distribution."""
    if platform.system() != "Linux":
        return Distro.UNKNOWN

    # Check /etc/os-release (standard on modern distros)
    os_release = Path("/etc/os-release")
    if os_release.exists():
        content = os_release.read_text().lower()
        if "arch" in content:
            return Distro.ARCH
        if "ubuntu" in content:
            return Distro.UBUNTU
        if "debian" in content:
            return Distro.DEBIAN

    return Distro.UNKNOWN


class GitConfig(BaseSettings):
    """Git user configuration - loaded from environment or prompted."""

    model_config = SettingsConfigDict(env_prefix="DOTFILES_GIT_")

    name: Annotated[str, Field(description="Git user name")] = ""
    email: Annotated[str, Field(description="Git user email")] = ""
    work_email: Annotated[str, Field(description="Git work email")] = ""
    work_remote_pattern: Annotated[str, Field(description="Pattern to match work remotes")] = ""


class Config(BaseSettings):
    """Main configuration for dotfiles CLI."""

    model_config = SettingsConfigDict(
        env_prefix="DOTFILES_",
        env_nested_delimiter="__",
    )

    # Paths
    home: Path = Field(default_factory=Path.home)
    dotfiles_dir: Path = Field(default_factory=lambda: Path(__file__).resolve().parents[2])

    # Runtime flags
    dry_run: bool = False
    verbose: bool = False

    # Git configuration (nested)
    git: GitConfig = Field(default_factory=GitConfig)

    @computed_field  # type: ignore[prop-decorator]
    @property
    def oh_my_zsh_dir(self) -> Path:
        """Path to Oh My Zsh installation."""
        return self.home / ".oh-my-zsh"

    @computed_field  # type: ignore[prop-decorator]
    @property
    def oh_my_zsh_custom(self) -> Path:
        """Path to Oh My Zsh custom directory."""
        return self.oh_my_zsh_dir / "custom"

    @computed_field  # type: ignore[prop-decorator]
    @property
    def proto_home(self) -> Path:
        """Path to proto installation."""
        return self.home / ".proto"

    @computed_field  # type: ignore[prop-decorator]
    @property
    def config_dir(self) -> Path:
        """Path to stow config packages."""
        return self.dotfiles_dir / "config"

    @computed_field  # type: ignore[prop-decorator]
    @property
    def scripts_dir(self) -> Path:
        """Path to scripts directory."""
        return self.dotfiles_dir / "scripts"

    @computed_field  # type: ignore[prop-decorator]
    @property
    def local_bin(self) -> Path:
        """Path to ~/.local/bin."""
        return self.home / ".local" / "bin"

    @computed_field  # type: ignore[prop-decorator]
    @property
    def distro(self) -> Distro:
        """Detected Linux distribution."""
        return detect_distro()

    @computed_field  # type: ignore[prop-decorator]
    @property
    def is_arch(self) -> bool:
        """Check if running on Arch Linux."""
        return self.distro == Distro.ARCH

    @computed_field  # type: ignore[prop-decorator]
    @property
    def is_ubuntu(self) -> bool:
        """Check if running on Ubuntu."""
        return self.distro == Distro.UBUNTU

    @computed_field  # type: ignore[prop-decorator]
    @property
    def is_debian_based(self) -> bool:
        """Check if running on Debian-based distro (Ubuntu, Debian)."""
        return self.distro in (Distro.UBUNTU, Distro.DEBIAN)

"""Configuration using Pydantic Settings."""

from pathlib import Path
from typing import Annotated

from pydantic import Field, computed_field
from pydantic_settings import BaseSettings, SettingsConfigDict


class GitConfig(BaseSettings):
    """Git user configuration - loaded from environment or prompted."""

    model_config = SettingsConfigDict(env_prefix="DOTFILES_GIT_")

    name: Annotated[str, Field(description="Git user name")] = ""
    email: Annotated[str, Field(description="Git user email")] = ""
    work_email: Annotated[str, Field(description="Git work email")] = ""
    work_remote_pattern: Annotated[
        str, Field(description="Pattern to match work remotes")
    ] = ""


class Config(BaseSettings):
    """Main configuration for dotfiles CLI."""

    model_config = SettingsConfigDict(
        env_prefix="DOTFILES_",
        env_nested_delimiter="__",
    )

    # Paths
    home: Path = Field(default_factory=Path.home)
    dotfiles_dir: Path = Field(
        default_factory=lambda: Path(__file__).resolve().parents[2]
    )

    # Versions
    node_version: str = "23"

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

"""Tests for configuration module."""

from pathlib import Path

import pytest

from dotfiles.config import Config, GitConfig


class TestGitConfig:
    """Tests for GitConfig."""

    def test_default_values(self) -> None:
        """Test that default values are empty strings."""
        config = GitConfig()
        assert config.name == ""
        assert config.email == ""
        assert config.work_email == ""
        assert config.work_remote_pattern == ""

    def test_from_env(self, monkeypatch: pytest.MonkeyPatch) -> None:
        """Test loading from environment variables."""
        monkeypatch.setenv("DOTFILES_GIT_NAME", "Test User")
        monkeypatch.setenv("DOTFILES_GIT_EMAIL", "test@example.com")

        config = GitConfig()
        assert config.name == "Test User"
        assert config.email == "test@example.com"


class TestConfig:
    """Tests for main Config."""

    def test_default_paths(self) -> None:
        """Test that default paths are set correctly."""
        config = Config()
        assert config.home == Path.home()
        assert config.dry_run is False
        assert config.verbose is False

    def test_computed_properties(self) -> None:
        """Test computed path properties."""
        config = Config()
        assert config.oh_my_zsh_dir == config.home / ".oh-my-zsh"
        assert config.oh_my_zsh_custom == config.home / ".oh-my-zsh" / "custom"
        assert config.proto_home == config.home / ".proto"
        assert config.local_bin == config.home / ".local" / "bin"

    def test_dry_run_flag(self) -> None:
        """Test dry_run flag."""
        config = Config(dry_run=True)
        assert config.dry_run is True

    def test_verbose_flag(self) -> None:
        """Test verbose flag."""
        config = Config(verbose=True)
        assert config.verbose is True


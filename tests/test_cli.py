"""Tests for CLI module."""

from typer.testing import CliRunner

from dotfiles.cli import app

runner = CliRunner()


class TestCLI:
    """Tests for CLI commands."""

    def test_help(self) -> None:
        """Test help command."""
        result = runner.invoke(app, ["--help"])
        assert result.exit_code == 0
        assert "Development environment setup CLI" in result.stdout

    def test_version(self) -> None:
        """Test version flag."""
        result = runner.invoke(app, ["--version"])
        assert result.exit_code == 0
        assert "dotfiles version" in result.stdout

    def test_install_help(self) -> None:
        """Test install command help."""
        result = runner.invoke(app, ["install", "--help"])
        assert result.exit_code == 0
        assert "Full installation" in result.stdout

    def test_sync_help(self) -> None:
        """Test sync command help."""
        result = runner.invoke(app, ["sync", "--help"])
        assert result.exit_code == 0
        assert "Update dotfiles" in result.stdout

    def test_uninstall_help(self) -> None:
        """Test uninstall command help."""
        result = runner.invoke(app, ["uninstall", "--help"])
        assert result.exit_code == 0
        assert "Remove symlinks" in result.stdout

    def test_status_command(self) -> None:
        """Test status command runs without error."""
        result = runner.invoke(app, ["status"])
        assert result.exit_code == 0
        assert "Dotfiles Status" in result.stdout

    def test_install_dry_run(self) -> None:
        """Test install with dry-run flag."""
        result = runner.invoke(app, ["install", "--dry-run"])
        assert result.exit_code == 0
        assert "DRY RUN" in result.stdout

    def test_sync_dry_run(self) -> None:
        """Test sync with dry-run flag."""
        result = runner.invoke(app, ["sync", "--dry-run"])
        assert result.exit_code == 0
        assert "DRY RUN" in result.stdout

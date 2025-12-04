"""Tests for runner module."""

import pytest

from dotfiles.runner import Runner, RunnerError


class TestRunner:
    """Tests for Runner class."""

    def test_dry_run_mode(self) -> None:
        """Test that dry run mode doesn't execute commands."""
        runner = Runner(dry_run=True)
        result = runner.run(["echo", "test"])
        assert result.returncode == 0
        assert result.stdout == ""

    def test_command_exists(self) -> None:
        """Test command existence check."""
        runner = Runner()
        assert runner.command_exists("ls") is True
        assert runner.command_exists("nonexistent_command_12345") is False

    def test_run_captures_output(self) -> None:
        """Test that run captures output when requested."""
        runner = Runner()
        result = runner.run(["echo", "hello"], capture=True)
        assert "hello" in result.stdout

    def test_run_raises_on_failure(self) -> None:
        """Test that run raises RunnerError on failure when check=True."""
        runner = Runner()
        with pytest.raises(RunnerError):
            runner.run(["false"], check=True)

    def test_run_no_raise_when_check_false(self) -> None:
        """Test that run doesn't raise when check=False."""
        runner = Runner()
        result = runner.run(["false"], check=False)
        assert result.returncode != 0

    def test_dry_run_shell(self) -> None:
        """Test dry run mode for shell commands."""
        runner = Runner(dry_run=True)
        result = runner.run_shell("echo test")
        assert result.returncode == 0


class TestRunnerError:
    """Tests for RunnerError exception."""

    def test_error_message(self) -> None:
        """Test error message formatting."""
        error = RunnerError(["git", "push"], 1, "Permission denied")
        assert "git push" in str(error)
        assert error.returncode == 1
        assert error.stderr == "Permission denied"

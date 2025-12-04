"""Subprocess runner with sudo caching and dry-run support."""

import logging
import shlex
import shutil
import subprocess
from subprocess import CompletedProcess

from dotfiles import console

logger = logging.getLogger(__name__)


class RunnerError(Exception):
    """Error during command execution."""

    def __init__(self, cmd: list[str], returncode: int, stderr: str = "") -> None:
        self.cmd = cmd
        self.returncode = returncode
        self.stderr = stderr
        super().__init__(f"Command failed: {' '.join(cmd)}")


class Runner:
    """Run shell commands with sudo caching and dry-run support."""

    def __init__(self, dry_run: bool = False, verbose: bool = False) -> None:
        self.dry_run = dry_run
        self.verbose = verbose
        self._sudo_validated = False

    def _ensure_sudo(self) -> None:
        """Validate sudo password once at the start."""
        if self._sudo_validated:
            return
        if self.dry_run:
            console.dry_run("Would prompt for sudo password")
            self._sudo_validated = True
            return

        result = subprocess.run(
            ["sudo", "-v"],
            capture_output=True,
            check=False,
        )
        if result.returncode != 0:
            raise RunnerError(["sudo", "-v"], result.returncode, result.stderr.decode())
        self._sudo_validated = True

    def run(
        self,
        cmd: list[str],
        *,
        sudo: bool = False,
        check: bool = True,
        capture: bool = False,
    ) -> CompletedProcess[str]:
        """Run a command, optionally with sudo.

        Args:
            cmd: Command and arguments as list
            sudo: Run with sudo
            check: Raise exception on non-zero exit
            capture: Capture stdout/stderr

        Returns:
            CompletedProcess with results

        Raises:
            RunnerError: If check=True and command fails
        """
        if sudo:
            self._ensure_sudo()
            cmd = ["sudo", *cmd]

        cmd_str = " ".join(shlex.quote(c) for c in cmd)

        if self.dry_run:
            console.dry_run(cmd_str)
            return CompletedProcess(cmd, 0, "", "")

        if self.verbose:
            logger.info("Running: %s", cmd_str)

        result = subprocess.run(
            cmd,
            capture_output=capture,
            text=True,
            check=False,
        )

        if check and result.returncode != 0:
            stderr = result.stderr if capture else ""
            raise RunnerError(cmd, result.returncode, stderr)

        return result

    def run_shell(
        self,
        script: str,
        *,
        sudo: bool = False,
        check: bool = True,
    ) -> CompletedProcess[str]:
        """Run a shell script via bash.

        Args:
            script: Shell script to execute
            sudo: Run with sudo
            check: Raise exception on non-zero exit

        Returns:
            CompletedProcess with results
        """
        if sudo:
            self._ensure_sudo()

        preview = script[:80] + "..." if len(script) > 80 else script

        if self.dry_run:
            console.dry_run(f"bash -c '{preview}'")
            return CompletedProcess(["bash", "-c", script], 0, "", "")

        if self.verbose:
            logger.info("Running shell: %s", preview)

        # Use list form to avoid shell injection
        cmd = ["sudo", "bash", "-c", script] if sudo else ["bash", "-c", script]

        result = subprocess.run(
            cmd,
            capture_output=True,
            text=True,
            check=False,
        )

        if check and result.returncode != 0:
            raise RunnerError(cmd, result.returncode, result.stderr)

        return result

    def command_exists(self, cmd: str) -> bool:
        """Check if a command exists on PATH."""
        return shutil.which(cmd) is not None

"""Console output using Rich."""

from rich.console import Console

console = Console()


def success(msg: str) -> None:
    """Print success message with green checkmark."""
    console.print(f"[green]✓[/green] {msg}")


def skip(msg: str) -> None:
    """Print skip message with yellow circle."""
    console.print(f"[yellow]○[/yellow] {msg}")


def error(msg: str) -> None:
    """Print error message with red X."""
    console.print(f"[red]✗[/red] {msg}")


def info(msg: str) -> None:
    """Print info message with blue arrow."""
    console.print(f"[blue]→[/blue] {msg}")


def header(msg: str) -> None:
    """Print bold header message."""
    console.print(f"\n[bold blue]{msg}[/bold blue]")


def warning(msg: str) -> None:
    """Print warning message."""
    console.print(f"[yellow]⚠[/yellow] {msg}")


def dry_run(msg: str) -> None:
    """Print dry-run message."""
    console.print(f"[dim][DRY-RUN][/dim] {msg}")

"""Task modules for dotfiles installation."""

from dotfiles.tasks.apt import install_apt_packages
from dotfiles.tasks.git import setup_git_config
from dotfiles.tasks.github import install_gh_extensions
from dotfiles.tasks.shell import (
    install_oh_my_zsh,
    install_zsh_plugins,
    set_default_shell,
    update_zsh_plugins,
)
from dotfiles.tasks.stow import (
    setup_directories,
    setup_local_bin,
    stow_configs,
    unstow_configs,
)
from dotfiles.tasks.tools import install_proto, install_proto_tools, install_tpm, update_tpm

__all__ = [
    "install_apt_packages",
    "install_gh_extensions",
    "install_oh_my_zsh",
    "install_proto",
    "install_proto_tools",
    "install_tpm",
    "install_zsh_plugins",
    "set_default_shell",
    "setup_directories",
    "setup_git_config",
    "setup_local_bin",
    "stow_configs",
    "unstow_configs",
    "update_tpm",
    "update_zsh_plugins",
]

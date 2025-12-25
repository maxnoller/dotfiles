{ pkgs, ... }:

{
  imports = [
    ./plugins.nix
    ./config.nix
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    # ═══════════════════════════════════════════════════════════════════════
    # LSPs, formatters, linters - replaces Mason!
    # ═══════════════════════════════════════════════════════════════════════
    extraPackages = with pkgs; [
      # Lua
      lua-language-server
      stylua

      # Python
      basedpyright
      ruff

      # TypeScript/JavaScript
      nodePackages.typescript-language-server

      # Web (HTML, CSS, JSON, ESLint)
      vscode-langservers-extracted

      # Nix
      nil
      nixfmt-classic

      # General tools
      nodePackages.prettier

      # For Telescope
      ripgrep
      fd
    ];
  };
}

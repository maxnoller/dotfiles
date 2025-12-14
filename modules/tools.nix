{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Developer Tools
    bun
    nodejs
    uv
    pnpm
    
    # Utilities
    ripgrep
    fd
    jq
    tree
    curl
  ];
}

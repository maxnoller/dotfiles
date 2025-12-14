{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Developer Tools
    bun
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

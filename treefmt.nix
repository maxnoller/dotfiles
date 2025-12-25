{ pkgs, ... }:
{
  projectRootFile = "flake.nix";
  programs.nixfmt.enable = true; # Standard formatter
  programs.statix.enable = true; # Linter
  programs.deadnix.enable = true; # Dead code detection
}

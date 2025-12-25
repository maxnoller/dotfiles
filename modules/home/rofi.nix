{ pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;

    # Basic configuration
    extraConfig = {
      modi = "drun,run";
      show-icons = true;
      terminal = "ghostty";
      drun-display-format = "{icon} {name}";
      disable-history = false;
      hide-scrollbar = true;
      sidebar-mode = false;
    };

    # NOTE: Theming is now handled by Stylix (nixos/stylix.nix)
    # Stylix auto-generates a theme based on the Nord color scheme
  };
}

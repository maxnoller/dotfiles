{ pkgs, ... }:

{
  # Cursor theme - Stylix doesn't manage cursors by default
  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.nordzy-cursor-theme;
    name = "Nordzy-cursors";
    size = 24;
  };

  # NOTE: GTK and Qt theming is now handled by Stylix (nixos/stylix.nix)
  # We only keep cursor config here since Stylix doesn't manage cursor themes
}

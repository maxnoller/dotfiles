{ pkgs, ... }:
{
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    installBatSyntax = true;

    settings = {
      theme = "nord";
      font-family = "JetBrainsMono Nerd Font";
      font-size = 12;

      # Transparency & Blur ("Rice" features)
      background-opacity = 0.8;
      background-blur-radius = 20;

      # Window decorations
      window-decoration = false;

      # Cursor
      cursor-style = "block";
      cursor-style-blink = true;
    };
  };
}

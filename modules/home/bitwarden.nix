{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bitwarden-desktop
    rbw # Unofficial Bitwarden CLI, better for scripts
    pinentry-gnome3 # For rbw pinentry
  ];

  # Basic RBW config (requires 'rbw login' manually first time)
  programs.rbw = {
    enable = true;
    settings = {
      email = "max@example.com"; # Replace with your email
      lock_timeout = 3600;
      pinentry = pkgs.pinentry-gnome3;
    };
  };
}

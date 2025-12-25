{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Max Noller"; # Assumed from path
        email = "max@example.com"; # Placeholder
      };
      init = {
        defaultBranch = "main";
      };
      # Add other git config here if needed
    };
  };

  programs.gh = {
    enable = true;
    extensions = [
      # If gh-act is not packaged, we can install 'act' separately
      # and use it directly, or try to find the extension package.
      # For now, we'll install 'act' which provides the functionality.
    ];
  };

  home.packages = [
    pkgs.act # Run GitHub Actions locally
  ];
}

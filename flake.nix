{
  description = "Max's Dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      # Helper function to create home configurations
      mkHome = { system ? "x86_64-linux", extraModules ? [] }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
            config.nvidia.acceptLicense = true;
          };
          extraSpecialArgs = { inherit inputs; };
          modules = [ ./home.nix ] ++ extraModules;
        };
    in
    {
      homeConfigurations = {
        # Desktop with NVIDIA GPU and GUI apps
        # Usage: home-manager switch --flake .#desktop
        "desktop" = mkHome {
          extraModules = [ ./hosts/desktop.nix ];
        };

        # Server without GPU or GUI apps
        # Usage: home-manager switch --flake .#server
        "server" = mkHome {
          extraModules = [ ./hosts/server.nix ];
        };
        
        # Legacy: keep "max" as alias to desktop for backwards compatibility
        "max" = mkHome {
          extraModules = [ ./hosts/desktop.nix ];
        };
      };
    };
}

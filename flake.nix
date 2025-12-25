{
  description = "Max's Dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:danth/stylix";
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      flake-parts,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];
      imports = [
        inputs.treefmt-nix.flakeModule
      ];

      perSystem =
        {
          config,
          self',
          inputs',
          pkgs,
          ...
        }:
        {
          # Auto-formatting
          treefmt.config = import ./treefmt.nix { inherit pkgs; };

          # DevShell
          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              git
              just
              nix-output-monitor
              nvd # Nix version diff
              statix
              deadnix
            ];
          };
        };

      flake =
        let
          system = "x86_64-linux";
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
            config.nvidia.acceptLicense = true;
          };

          # Helper function to create home configurations
          mkHome =
            {
              extraModules ? [ ],
            }:
            home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              extraSpecialArgs = { inherit inputs; };
              modules = [ ./home.nix ] ++ extraModules;
            };

          # Helper function to create NixOS system configurations
          mkNixOS =
            {
              hostname,
              extraModules ? [ ],
              homeModules ? [ ],
            }:
            nixpkgs.lib.nixosSystem {
              inherit system;
              specialArgs = { inherit inputs; };
              modules = [
                ./systems/nixos/nixos-desktop/default.nix
                { networking.hostName = hostname; }
                inputs.stylix.nixosModules.stylix
                home-manager.nixosModules.home-manager
                {
                  home-manager.useGlobalPkgs = true;
                  home-manager.useUserPackages = true;
                  home-manager.extraSpecialArgs = { inherit inputs; };
                  home-manager.users.max = {
                    imports = [ ./home-nixos.nix ] ++ homeModules;
                  };
                }
              ]
              ++ extraModules;
            };
        in
        {
          # ============================================
          # Standalone Home Manager
          # ============================================
          homeConfigurations = {
            "desktop" = mkHome {
              extraModules = [ ./systems/home/desktop/default.nix ];
            };
            "server" = mkHome {
              extraModules = [ ./systems/home/server/default.nix ];
            };
          };

          # ============================================
          # NixOS Systems
          # ============================================
          nixosConfigurations = {
            "desktop-vm" = mkNixOS {
              hostname = "nixos-desktop";
              extraModules = [ ./modules/nixos/hardware-vm.nix ];
            };

            "desktop-nixos" = mkNixOS {
              hostname = "nixos-desktop";
              extraModules = [
                ./modules/nixos/hardware-nvidia.nix
                # ./modules/nixos/hardware-configuration.nix # On real install
              ];
            };
          };
        };
    };
}

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
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      homeConfigurations."max" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Pass inputs to modules so we can use them there
        extraSpecialArgs = { inherit inputs; };

        modules = [
          ./home.nix
        ];
      };
    };
}

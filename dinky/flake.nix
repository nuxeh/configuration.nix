{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    #nixpkgs.url = "github:nixos/nixpkgs?rev=bedc4e5192fc213fc959639a3e636bf29f6b010c";
    nixpkgs-url-bot.url = "github:nixos/nixpkgs?rev=4e5f0ca4b33180243f2c6e9bd25951ce3ed4a1b6";

    url-bot.url = github:nuxeh/url-bot-rs/flake-test;

    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = { home-manager, nixpkgs, url-bot, ... }@inputs: {
    nixosConfigurations = {
      "dinky-nix" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          #{ nixpkgs.overlays = [ url-bot.overlay ]; }

          #(import ./modules/url-bot-rs.nix)

          #nixpkgs.lib.nixosSystem.modules.vmConfig

          ./configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.ed = import ./home.nix;
          }
        ];
        specialArgs = { inherit inputs; };
      };
    };
  };
}

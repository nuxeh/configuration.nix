{
  description = "NixOS configuration";

  inputs = {
    #nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs?rev=bedc4e5192fc213fc959639a3e636bf29f6b010c";
    nixpkgs-url-bot.url = "github:nixos/nixpkgs?rev=4e5f0ca4b33180243f2c6e9bd25951ce3ed4a1b6";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = { home-manager, nixpkgs, nixpkgs-url-bot, ... }@inputs: {

#    packages.x86_64-linux = let
#      pkgs = import nixpkgs {
#        system = "x86_64-linux";
#        config.allowUnfree = true;
#      }; in {
#        url-bot-rs = pkgs.callPackage nixpkgs-url-bot.legacyPackages.x86_64-linux.url-bot-rs {};
#      };

    nixosConfigurations = {
      "dinky-nix" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          #(import ./modules/url-bot-rs.nix)

          #nixpkgs-url-bot.modules.url-bot-rs
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

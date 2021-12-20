{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-url-bot.url = "github:nixos/nixpkgs?rev=4e5f0ca4b33180243f2c6e9bd25951ce3ed4a1b6";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = { home-manager, nixpkgs, nixpkgs-url-bot, ... }: {
    nixosConfigurations = {
      "dinky-nix" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          #(import ./modules/url-bot-rs.nix)

          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.ed = import ./home.nix;
          }
        ];
      };
    };
  };
}

{ inputs, ... }: {
  imports = [ "${inputs.nixpkgs-url-bot-rs}/nixos/modules/services/networking/url-bot-rs.nix" ];
}

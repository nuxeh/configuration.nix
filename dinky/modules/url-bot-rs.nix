{ inputs, ... }: {
  imports = [ "${inputs.nixpkgs-url-bot}/nixos/modules/services/networking/url-bot-rs.nix" ];
}

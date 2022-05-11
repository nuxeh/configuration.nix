{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget

  environment.systemPackages = with pkgs; [
      #url-bot-rs
      file
      firefox
      freecad
      gnome3.gnome-tweaks
      google-chrome
      htop
      inkscape
      kicad
      nixos-shell
      platformio
      screen
      shotwell
      simplescreenrecorder
      solvespace
      spotify
      tilix
      tor-browser-bundle-bin
      transmission
      vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      wget
      zoom-us
  ];
}

{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget

  environment.systemPackages = with pkgs; [
      file
      firefox
      gnome3.gnome-tweaks
      google-chrome
      htop
      kicad
      platformio
      screen
      shotwell
      solvespace
      spotify
      vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      wget
  ];
}

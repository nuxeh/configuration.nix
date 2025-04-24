{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget

  environment.systemPackages = with pkgs; [
      #url-bot-rs
      #supertux
      catdoc
      #exodus
      file
      firefox
      fstl
      #flatcam
      freecad
      gimp
      gnome-tweaks
      google-chrome
      hashcat
      hashcat-utils
      htop
      inetutils # for telnet
      inkscape
      intel-compute-runtime
      kicad
      nixos-shell
      platformio
      puredata
      pulseview
      screen
      shotwell
      simplescreenrecorder
      solvespace
      spotify
      scrcpy
      tilix
      tor-browser-bundle-bin
      transmission
      tree
      usbutils
      vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      wget
      wine
      winetricks
      zoom-us
      vlc
  ];
}

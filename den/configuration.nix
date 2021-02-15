# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

with builtins; let

  local = import <local> { config.allowUnfree = true; };

  #ringcentralPin = import (pkgs.fetchFromGitHub {
  #    owner = "nuxeh";
  #    repo = "nixpkgs";
  #    rev = "71e36f320f1274712c530fe188e98ea3c9d4d54b";
  #    sha256 = "1c7s7nl1asn5xxl18iv5hdfq5jap77d3sp93c0833wgsildy72sv";
  #  }) { config.allowUnfree = true; };

  home-manager-git = builtins.fetchGit {
    url = "https://github.com/rycee/home-manager.git";
    rev = "dd94a849df69fe62fe2cb23a74c2b9330f1189ed";
    ref = "master";
  };

  home-manager = builtins.fetchTarball "https://github.com/rycee/home-manager/archive/master.tar.gz";

in {

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (import "${home-manager}/nixos")
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  home-manager.users.ed = import /home/ed/.config/nixpkgs/home.nix;

  #boot.binfmt.emulatedSystems = [ "aarch64-linux" "armv7l-linux" ];

  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp37s0.useDHCP = true;
  networking.interfaces.wlp38s0.useDHCP = true;

  # static ip for domoticz
  #networking = {
  #  usePredictableInterfaceNames = false;
  #  interfaces.eth0.ipv4.addresses = [{
  #    address = "192.168.1.160";
  #    prefixLength = 24;
  #  }];
  #  defaultGateway = "192.168.1.254";
  #  nameservers = [ "192.168.1.254" "1.1.1.1" "8.8.8.8" ];
  #};

  #virtualisation.docker.enable = true;
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true; # Create a `docker` alias for podman, to use it as a drop-in replacement
    };
  };

  # Container instances
#  containers.pihole-test = {
#    config =
#        { config, pkgs, ... }:
#        with builtins; let
#          piholepkgs = import <piholepkgs> {};
#        in {
#          nixpkgs.overlays = [
#            self: super: {
#              pihole = self.callPac
#            };
#          ];
#
#          services.pihole = {
#            enable = true;
#            interface = "ens3";
#            webInterface = true;
#          };
#        };
#    };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Set your time zone.
  time.timeZone = "Europe/London";

  # allow non-free
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget htop file tree
    vim amp
    git #git-subrepo
    firefox
    gnome3.gnome-tweaks cups
    platformio arduino screen
    #pkgsCross.avr.buildPackages.gcc
    tor-browser-bundle-bin gnupg exodus
    zola
    python3
    rustup
    gimp inkscape
    thefuck
    spotify
    zoom-us
    feh
    kicad-small
    fstl #local.candle
    solvespace
    nix-prefetch-github
    audacity
    vlc
    youtube-dl
    transmission
    google-chrome
    jq
    clang
    alacritty
    libreoffice
    eagle
    unrar
    cachix
    hunspell
    pwgen
    pandoc
    wkhtmltopdf
    steam
    nixos-shell
    #slic3r
    #freecad
    asciinema
    #docker
    #local.ringcentral-meetings
    openvpn
    wine winetricks
    signal-desktop
    #flutter-beta
    #debootstrap
    binutils.bintools
    timewarrior
    texlive.combined.scheme-small
    #callPackage (import flutterPackages.mkFlutter) { beta };
    #cudatoolkit
    powerline-fonts
    gnomeExtensions.system-monitor
    hdparm
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  #   pinentryFlavor = "gnome3";
  # };
  programs.fish.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable dnsmasq
  services.dnsmasq.enable = false;

  # domoticz
  services.domoticz.enable = false;

  # softiron vpn
  #services.pritunl.enable = true;
  services.openvpn.servers = {
    softironVPN  = {
      config = '' config /home/ed/work/softiron/softiron_r/softiron_r_abs.ovpn '';
      updateResolvConf = true;
      autoStart = false;
    };
  };

  programs.ssh.extraConfig = ''
    Host git.softiron.com
      IdentityFile /home/ed/work/softiron/softiron_r/softiron
  '';

  services.mosquitto = {
    enable = false;
    host = "0.0.0.0";
    port = 1883;
    users = {
      device = {
        hashedPassword = "$6$U1xPVIdiyB8xgtvC$/IsgFqB0pYcrQJRXwv+L007QYm961ulm+2p7rUqf1C4vEnqEkMll4dcL22S3gSnHdawoqnKlKuYM9zA7T4UFIw==";
        acl = [
          "topic readwrite office/#"
          "topic readwrite house/#"
          "topic readwrite den/#"
          "topic readwrite domoticz/#"
        ];
      };
    };
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 8266 28266 8080 8081 1883 5901 ];
  #networking.firewall.allowedUDPPorts = [ 1883 ];
  # Or disable the firewall altogether.
  #networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome3.enable = true;

  services.printing.enable = true;
  services.printing.drivers = [
    pkgs.gutenprint
    pkgs.gutenprintBin
  ];

  # automatically spin down /dev/sda
  powerManagement.powerUpCommands = ''
    ${pkgs.hdparm}/sbin/hdparm -B 1 /dev/sda
  '';

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ed = {
    isNormalUser = true;
    extraGroups = [ "wheel" "dialout" ];
    shell = pkgs.fish;
  };

  users.users.root.openssh.authorizedKeys.keys = [
     "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDAGi1FARap8otpQxJWwPx4k9y6E2n22PvRbvXKdCKnYZoSWbuGdtlrZoiwZjVkLiZa+eBWdSZks4T1SRAf36TdECaViVp0RIBp5r2JJiiXFtMcfKsqIcorjNM7IO1aQE8RcAT8BbYWY1T2LqSszhIyHWn5fCBgoChzVbw6kkoQvti5t0xJDdGufizaPxzORwK2xxe3vjhK1Vla6OhUoLyDcCIdzHPcWwD0TANbt09QHbV8u1idPPlS7d8sjPfZ8qt3tcWCBiM5az5+U8vg/zF5fy6FzKWhG7A6l2hdc2zR6tWTb5e+25yUOrp2vUd6ziZRXu4PYb8M4HKyAn2yu3/0kfmdR1G63dWuK/nr6yKoSrGTgGTHABAUWkZcvarWQ9HGeup/OUBXjpPZmTmkogDyRiXJnQtWpQGidAHXzYrnYgWIwZN4IInRP6MMNTK2esSIZlHlhgRXld5YxaFdXSUpn68tpPEqUiEaX4eLloF8ok/db2kJS68mEL7zkKD9ZaM= pi@nixos"
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?

}


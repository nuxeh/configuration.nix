# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./system-packages.nix
      #<nixpkgs/nixos/modules/virtualisation/qemu-vm.nix>
    ];

  nixpkgs.overlays = [
    #(import ./url-bot-rs/overlay.nix)
  ];

  # Non free
  nixpkgs.config.allowUnfree = true;

  # Storage optimisation
  nix.autoOptimiseStore = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Enable nix flakes
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Virtualisation
  #virtualisation = {
  #  memorySize = 8192; 
  #};

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.enableCryptodisk = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  #boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda";
  # boot.loader.grub.device = "nodev"; # EFI only
  #boot.loader.efi.canTouchEfiVariables = true;
  
  #boot.initrd.luks.devices = { 
  #  root = {
  #    name = "root";
  #    device = "/dev/disk/by-uuid/818ca41e-0fc9-41e7-84f2-b9a767f7f073";
  #    preLVM = true;
  #    allowDiscards = true;
  #  };
  #};

  # SSD options
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  # Networking
  networking.hostName = "dinky-nix"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.wireless.interfaces = [ "wlp4s0" ];
  # networking.wireless.networks."TP-Link_B37A".pskRaw = "54289bcfdccdcb7f51ba519d0506ed6e08cb1cd5f9e17db208c2bb218019cb27";

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.wlp4s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  services.url-bot-rs = {
    enable = true;
    server = "irc.nomnomnomnom.co.uk";
    settings = {
      "default" = {
        "plugins" = {
          "imgur" = {
            "api_key" = "";
          };
          "youtube" = {
            "api_key" = "";
          };
          "vimeo" = {
            "api_key" = "";
          };
        };
        "network" = {
          "name" = "default";
          "enable" = true;
        };
        "features" = {
          "report_metadata" = false;
          "report_mime" = false;
          "mask_highlights" = false;
          "send_notice" = false;
          "history" = false;
          "cross_channel_history" = false;
          "invite" = false;
          "autosave" = false;
          "send_errors_to_poster" = false;
          "reply_with_errors" = false;
          "partial_urls" = false;
          "nick_response" = false;
          "reconnect" = false;
        };
        "parameters" = {
          "url_limit" = 10;
          "status_channels" = [];
          "nick_response_str" = "";
          "reconnect_timeout" = 10;
        };
        "http" = {
          "timeout_s" = 10;
          "max_redirections" = 10;
          "max_retries" = 3;
          "retry_delay_s" = 5;
          "accept_lang" = "en";
        };
        "database" = {
          "type" = "in-memory";
        };
        "connection" = {
          "nickname" = "url-bot-rs";
          "nick_password" = "";
          "alt_nicks" = [
            "url-bot-rs_"
          ];
          "username" = "url-bot-rs";
          "realname" = "url-bot-rs";
          "server" = "irc.nomnomnomnom.co.uk";
          "port" = 26067;
          "password" = "chaesachoeGohzah1soo6OhTeefeiloo";
          "use_ssl" = false;
          "channels" = [
            "#url-bot-rs-test"
          ];
          "user_info" = "Feed me URLs.";
        };
      };
    };
  };

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.jane = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  # };
  #

  # Initial passwrdless root
  # users.users.root.initialHashedPassword = "";

  users = {
    mutableUsers = false;
    users = {
      ed = {
        isNormalUser = true;
        extraGroups = [ "wheel" "networkmanager" "dialout" ];
        home = "/home/ed/";
        shell = pkgs.fish;
        hashedPassword = "$6$/G.qBySWc$a6wVNc6QOoQNAO6kw.f01domc26TsZJ9adM5gSmUdm1l4t/S.j0A.lAfKRVmcRiEvN/NrH6ZRSIaXFMwtLqeO1";
      };
      root = {
        extraGroups = [ "dialout" ];
      };
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.fish.enable = true;

  # List services that you want to enable:
  services.domoticz.enable = true;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 8080 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

}


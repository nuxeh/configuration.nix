{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "ed";
  home.homeDirectory = "/home/ed/";

  # vim
  programs.vim = {
    enable = true;

    plugins = with pkgs.vimPlugins; [
      vim-airline
      vimwiki
      nerdtree
      gitgutter
      vim-fugitive
    ];

    settings = {
      ignorecase = true;
    };

    extraConfig = ''
      set mouse=a
      set updatetime=100
      autocmd VimEnter * GitGutterEnable
      cmap W w
      cmap Q q
    '';
  };

  # git
  programs.git = {
    enable = true;

    delta.enable = true;

    userEmail = "ed.cragg@eipi.xyz";
    userName = "Ed Cragg";

    aliases = {
      co = "checkout";
      ct = "commit";
      st = "status";
    };

    extraConfig = {
      core = {
        editor = "vim";
      };
    };
  };

  programs.gh = {
    enable = true;
  };

  # fish
  programs.fish = {
    enable = true;

    shellAliases = {
      g = "git";
      gs = "git status";
      gc = "git diff --cached";
      gd = "git diff";
      vi = "vim";
    };
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.05";
}

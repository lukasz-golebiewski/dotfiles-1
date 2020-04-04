{ config, pkgs, ... }:

let
  mozilla-overlays = fetchTarball {
    url = "https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz";
  };

  nixpkgs_with_rust_analyzer = import (fetchGit {
    name = "nixpkgs_with_rust_analyzer";
    url = "https://github.com/oxalica/nixpkgs/";
    ref = "rust-analyzer";
    rev = "bde9289415bae0e62e67072e22f5666da4c3a9f5";
  }) { };

in {
  imports =
    [ ../programs/zsh ../programs/neovim ../programs/tmux ../programs/emacs ];

  # Make the mozilla overlays available to home-manager, because they
  # contain firefox nightly
  nixpkgs.overlays = [
    (import "${mozilla-overlays}")
    (import ../overlays/personal-overlay)
  ];

  # Also make the overlay permanent so that we can use the rust
  # overlays in our projects
  xdg.configFile."rust-overlay.nix" = {
    source = "${mozilla-overlays}/rust-overlay.nix";
    target = "nixpkgs/overlays/rust-overlay.nix";
  };

  fonts.fontconfig.enable = true;

  # Enhanced nix-shell
  services.lorri.enable = true;

  home.packages = with pkgs; [
    nixpkgs_with_rust_analyzer.rust-analyzer
    latest.firefox-nightly-bin
    gitAndTools.diff-so-fancy
    deluge
    hack-font
    iosevka
    nerdfonts
    exa
    bat
    tokei
    xsv
    fd
    tmux
    htop
    dfc
    nixfmt
    calibre
    discord
    vlc
    filezilla
    unzip
    du-dust
    # licensor
    robo-instructus
  ];

  programs.git = {
    enable = true;
    userEmail = "corentinhenry@gmail.com";
    userName = "little-dude";
    extraConfig = {
      push = { default = "matching"; };
      core = {
        editor = "nvim";
        # excludesfile = "/home/corentih/.config/git/gitignore";
        ignorecase = false;
        pager = "diff-so-fancy | less --tabs=4 -RFX";
      };
      github = { user = "little-dude"; };
      forge = {
        # By default, forge uses the remote named "origin" as the
        # *upstream*, but we follow a different convention where
        # "upstream" is the upstream remote and "origin" is our own
        # fork.
        remote = "upstream";
      };
      color = {
        ui = true;
        diff-highlight = {
          oldNormal = "red bold";
          oldHighlight = "red bold 52";
          newNormal = "green bold";
          newHighlight = "green bold 22";
        };
        diff = {
          meta = 11;
          frag = "magenta bold";
          commit = "yellow bold";
          old = "red bold";
          new = "green bold";
          whitespace = "red reverse";
        };
      };
    };
  };
}

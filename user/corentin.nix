{ config, pkgs, ... }:

let
  mozilla-overlays = fetchTarball {
    url = "https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz";
  };

in {
  imports =
    [ ../programs/zsh ../programs/neovim ../programs/tmux ../programs/emacs ];

  # Make the mozilla overlays available to home-manager, because they
  # contain firefox nightly
  nixpkgs.overlays =
    [ (import "${mozilla-overlays}") (import ../overlays/personal-overlay) ];

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
    # fonts
    hack-font
    iosevka
    nerdfonts

    # cli tools
    exa
    bat
    tokei
    xsv
    fd
    tmux
    htop
    dfc
    nixfmt
    unzip
    exercism
    socat
    pciutils

    # dev tools
    shellcheck
    cargo-license
    cargo-tree
    rust-analyzer
    gitAndTools.diff-so-fancy
    # tex and pandoc are always useful, for instance for converting
    # markdown to pdf
    # texlive.combined.scheme-full
    pandoc

    # apps
    calibre
    discord
    vlc
    filezilla
    latest.firefox-nightly-bin
    deluge
    du-dust
    dbeaver
    dia
    google-chrome
    libreoffice
    skypeforlinux
    teams
    zoom-us

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

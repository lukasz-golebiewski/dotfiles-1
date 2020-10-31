{ config, pkgs, ... }:

let
  mozilla-overlays = fetchTarball {
    url = "https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz";
  };
  # The whole nerdfonts package is > 2GB, and we only need two fonts.
  nerdfonts = pkgs.nerdfonts.override { fonts = [ "Hack" "Iosevka" ]; };

in {
  home.username = "little-dude";
  home.homeDirectory = "/home/little-dude";

  # FIXME: remove this when possible. Currently, this is a dependency of sweethome3d
  nixpkgs.config.permittedInsecurePackages = [ "p7zip-16.02" ];

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
  # The rust-src overlay contains rust-analyzer
  xdg.configFile."rust-src-overlay.nix" = {
    source = "${mozilla-overlays}/rust-src-overlay.nix";
    target = "nixpkgs/overlays/rust-src-overlay.nix";
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
    ripgrep
    du-dust
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
    httpie
    pgcli
    cookiecutter

    # dev tools
    shellcheck
    cargo-license
    rust-analyzer
    gitAndTools.diff-so-fancy
    perl # needed for git diff???
    # tex and pandoc are always useful, for instance for converting
    # markdown to pdf
    texlive.combined.scheme-full
    pandoc

    # apps
    calibre
    discord
    vlc
    filezilla
    latest.firefox-nightly-bin
    deluge
    dbeaver
    dia
    google-chrome
    libreoffice
    skypeforlinux
    teams
    zoom-us
    sweethome3d.application
    evince

    # licensor
    # robo-instructus
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

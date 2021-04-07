{ pkgs, ... }:

let
  mozilla-overlays = fetchTarball {
    url = "https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz";
  };
  rust-overlay = fetchTarball {
    url = "https://github.com/oxalica/rust-overlay/archive/master.tar.gz";
  };
  # The whole nerdfonts package is > 2GB, and we only need two fonts.
  nerdfonts = pkgs.nerdfonts.override { fonts = [ "Hack" "Iosevka" ]; };

in rec {
  home.username = "little-dude";
  home.homeDirectory = "/home/little-dude";

  # FIXME: remove this when possible. Currently, this is a dependency of sweethome3d
  nixpkgs.config.permittedInsecurePackages = [ "p7zip-16.02" ];

  imports = [
    ../programs/zsh
    ../programs/neovim
    ../programs/tmux
    ../programs/emacs
    (import ../programs/git { workdir = "${home.homeDirectory}/data/work"; })
  ];

  # Make the mozilla overlays available to home-manager, because they contain firefox nightly
  nixpkgs.overlays = [
    (import "${mozilla-overlays}")
    (import ../overlays/personal-overlay)
    (import "${rust-overlay}")
  ];

  # Also make the overlay permanent so that we can use the rust
  # overlays in our projects
  xdg.configFile."rust-overlay.nix" = {
    source = "${rust-overlay}/default.nix";
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
    wget
    glow
    youtube-dl
    moreutils
    asciinema
    inetutils
    kubectl
    lsof
    pgformatter
    xclip

    # dev tools
    clang-tools
    valgrind
    binutils
    strace
    file
    shellcheck
    cargo-license
    gitAndTools.diff-so-fancy
    perl # needed for git diff???
    # tex and pandoc are always useful, for instance for converting
    # markdown to pdf
    texlive.combined.scheme-full
    pandoc
    virt-manager

    # apps
    wireshark-qt
    pavucontrol
    calibre
    discord
    vlc
    filezilla
    latest.firefox-nightly-bin
    deluge
    dbeaver
    dia
    gimp
    google-chrome
    libreoffice
    teams
    zoom-us
    evince

    # licensor
    # robo-instructus
  ];
}

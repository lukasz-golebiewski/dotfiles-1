{ config, pkgs, ... }:

let
  rust-overlay = fetchTarball {
    url = "https://github.com/oxalica/rust-overlay/archive/master.tar.gz";
  };
in rec {
  # Make the mozilla overlays available to home-manager, because they contain firefox nightly
  nixpkgs.overlays = [ (import "${rust-overlay}") ];

  # Also make the overlay permanent so that we can use the rust
  # overlays in our projects
  xdg.configFile."rust-overlay.nix" = {
    source = "${rust-overlay}/default.nix";
    target = "nixpkgs/overlays/rust-overlay.nix";
  };

  # Enhanced nix-shell
  services.lorri.enable = true;

  home.packages = with pkgs; [
    gnome3.gnome-tweaks
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
    xclip

    # dev tools
    clang-tools
    valgrind
    binutils
    strace
    file
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
    deluge
    dbeaver
    dia
    gimp
    google-chrome
    libreoffice
    teams
    zoom-us
  ];
}

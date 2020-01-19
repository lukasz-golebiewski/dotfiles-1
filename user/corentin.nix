{ config, pkgs, ... }:

let
  mozilla-overlays = fetchTarball {
      url = https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz;
  };

in {
  imports = [
    ../programs/zsh
    ../programs/neovim
    ../programs/tmux
    ../programs/emacs
  ];

  # Make the mozilla overlays available to home-manager, because they
  # contain firefox nightly
  nixpkgs.overlays = [ (import "${mozilla-overlays}") ];

  # Also make the overlay permanent so that we can use the rust
  # overlays in our projects
  xdg.configFile."rust-overlay.nix" = {
    source = "${mozilla-overlays}/rust-overlay.nix";
    target = "nixpkgs/overlays/rust-overlay.nix";
  };

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    latest.firefox-nightly-bin
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
  ];

  programs.git = {
    enable = true;
    userEmail = "corentinhenry@gmail.com";
    userName = "little-dude";
  };
}

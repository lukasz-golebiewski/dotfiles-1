{ pkgs, settings, ... }:

let
  mozilla-overlays = fetchTarball {
    url = "https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz";
  };
  # The whole nerdfonts package is > 2GB, and we only need two fonts.
  nerdfonts = pkgs.nerdfonts.override { fonts = [ "Hack" "Iosevka" ]; };
in rec {
  home.username = "little-dude";
  home.homeDirectory = "/home/little-dude";
  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
  };
  xdg.enable = true;
  xdg.mime.enable = true;

  imports = [
    (import ../programs/zsh { inherit pkgs settings home; })
    ../programs/neovim
    ../programs/tmux
    ../programs/emacs
    (import ../programs/git { inherit settings; })
  ];

  # Make the mozilla overlays available to home-manager, because they contain firefox nightly
  nixpkgs.overlays =
    [ (import "${mozilla-overlays}") (import ../overlays/personal-overlay) ];

  fonts.fontconfig.enable = true;

  services.lorri.enable = true;

  programs.go.enable = true;
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
    pgcli
    pgformatter
    diff-so-fancy

    # dev tools
    shellcheck

    # apps
    latest.firefox-nightly-bin
    evince

    # licensor
    # robo-instructus
  ];
}

{ config, pkgs, ... }:

{
  imports = [
    ../programs/zsh
    ../programs/neovim
    ../programs/tmux
    ../programs/emacs
  ];

  fonts.fontconfig.enable = true;

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
  ];

  programs.git = {
    enable = true;
    userEmail = "corentinhenry@gmail.com";
    userName = "little-dude";
  };
}

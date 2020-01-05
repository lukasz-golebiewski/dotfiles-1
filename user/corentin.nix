{ config, pkgs, ... }:

{
  imports = [
    ../programs/zsh
    ../programs/neovim
    ../programs/tmux
  ];

  home.packages = with pkgs; [
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

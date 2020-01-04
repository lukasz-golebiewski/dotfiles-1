{ config, pkgs, ... }:

{
  imports = [
    ../programs/neovim/default.nix
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

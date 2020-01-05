{ config, lib, pkgs, ... }:

{
  programs.zsh = {
    enable = true;

    enableCompletion = true;
    autocd = true;
    defaultKeymap = "emacs";
    dotDir = ".config/zsh";
    history.expireDuplicatesFirst = true;
    shellAliases = {
      ".." = "cd ..";
      # we don't want to alias cat to bat because sometimes we do need to use
      # the real `cat`
      c = "bat";
      ls = "exa";
      ll = "ls -l";
    };
  };
}

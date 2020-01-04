{ config, lib, pkgs, ... }:

# {
#   xdg.configFile.".tmux.conf".source = ./tmux.conf;
# }

{
  programs.tmux = {
    enable = true;
    extraConfig = builtins.readFile ./tmux.conf;
  };
}


{ config, lib, pkgs, ... }:

# {
#   xdg.configFile."nvim/init.vim".source = ./init.vim;
# }

{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    extraConfig = builtins.readFile ./init.vim;
  };
}

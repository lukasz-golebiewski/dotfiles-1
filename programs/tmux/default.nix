{ pkgs, ... }:

# {
#   xdg.configFile.".tmux.conf".source = ./tmux.conf;
# }

with pkgs.python38Packages; {
  home.packages = [ powerline ];
  programs.tmux = {
    enable = true;
    extraConfig = ''
      run-shell "powerline-daemon -q"
      source ${powerline}/share/tmux/powerline.conf
    '' + builtins.readFile ./tmux.conf;
  };
}

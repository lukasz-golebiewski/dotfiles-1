{ pkgs, settings, home, ... }:

let
  zshEnv = if !settings.isNixOS then ''
    source "${home.homeDirectory}/.cargo/env"
    if [ -e ${home.homeDirectory}/.nix-profile/etc/profile.d/nix.sh ]; then . /${home.homeDirectory}/.nix-profile/etc/profile.d/nix.sh; fi
    export NIX_PATH=$HOME/.nix-defexpr/channels''${NIX_PATH:+:}$NIX_PATH
    # For stuff not managed by nix. For instance we put rust-analyzer there on Debian, when we manage rust via rustup
    export PATH=''${PATH}:''${HOME}/.local/bin
  '' else
    "";
  zshProfile = if !settings.isNixOS then ''
    export XDG_DATA_DIRS="${home.homeDirectory}/.nix-profile/share:$XDG_DATA_DIRS"
  '' else
    "";

in rec {
  home.packages = [ pkgs.direnv pkgs.fzf pkgs.starship ];

  programs.zsh = {
    profileExtra = zshProfile;
    envExtra = zshEnv;
    enable = true;
    # autocd = true;
    defaultKeymap = "emacs";
    dotDir = ".config/zsh";
    plugins = [
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "de95d50bce6f16fad7e20e9bf1fb7bff710dbcfd";
          sha256 = "142c031fqkjjmcj9yg6n1026km6h19nmg2nfkjpwipnliimi92qv";
        };
      }
      {
        name = "zsh-autosuggestions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-autosuggestions";
          rev = "ae315ded4dba10685dbbafbfa2ff3c1aefeb490d";
          sha256 = "0h52p2waggzfshvy1wvhj4hf06fmzd44bv6j18k3l9rcx6aixzn6";
        };
      }
    ];
    shellAliases = {
      # we don't want to alias cat to bat because sometimes we do need to use
      # the real `cat`
      c = "bat";
      ls = "exa";
      ll = "exa -l";
      la = "exa -a";
      lla = "exa -al";
      lal = "exa -al";
      tree = "exa --tree --level=3";
      virsh = "virsh -c qemu:///system";
      diff = "git diff --no-index";

    };
    initExtra = builtins.readFile ./zshrc;
  };

  home.file = {
    "starship-prompt.toml" = {
      target = "${programs.zsh.dotDir}/starship-prompt.toml";
      source = ./starship-prompt.toml;
    };
  };
}

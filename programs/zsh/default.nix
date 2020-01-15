{ config, lib, pkgs, ... }:

{
  programs.zsh = {
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
        name = "powerlevel10k";
        file = "powerlevel10k.zsh-theme";
        src = pkgs.fetchFromGitHub {
          owner = "romkatv";
          repo = "powerlevel10k";
          rev = "8ef2b737d1f6099966a1eb16bdfc90d67b367f22";
          sha256 = "02b25klkyyhpdbf2vwzzbrd8hnfjpckbpjy6532ir6jqp2n2ivpj";
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
      ll = "ls -l";
    };
    initExtra = builtins.readFile ./zshrc;
  };
}

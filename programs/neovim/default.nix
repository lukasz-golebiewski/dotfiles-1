{ pkgs, ... }:

# {
#   xdg.configFile."nvim/init.vim".source = ./init.vim;
# }

{
  programs.neovim = {
    withPython = false;
    enable = true;
    vimAlias = true;
    viAlias = true;
    plugins = with pkgs.vimPlugins; [
      neodark-vim
      vim-fugitive
      vim-nix
      vim-gitgutter
      python-mode
      nerdtree
      vim-tmux-navigator
      vim-airline
      vim-unimpaired
      # YouCompleteMe
      vim-surround
      vim-toml
      syntastic
      LanguageClient-neovim
    ];
    extraConfig = builtins.readFile ./init.vim;
  };
}

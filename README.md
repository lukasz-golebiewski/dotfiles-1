The `neovim` is currently slightly broken because we rely on
`vim-plug` for plugin management. Thus, the first time the
editor is started we need to install the plugin with
`:PlugInstall`. Then, parts of `YouCompleteMe` need to be
compiled manually, which is quite painful to do manually on
nixos.

See also: https://github.com/rycee/home-manager/issues/416

# The emacs config is adapted from
# https://github.com/willbush/system/blob/a5194a36ddce655726cb4b060fa917d0603ddc95/nixos/emacs.nix

{ pkgs, fetchFromGitHub, ... }:

let
  emacs-overlay = import (builtins.fetchTarball {
    url =
      "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
  });
in {
  nixpkgs.overlays = [ emacs-overlay ];
  # Treemacs requires python3
  home.packages = [ pkgs.python3 ];
  services.emacs.enable = true;
  programs.emacs = {
    enable = true;
    extraPackages = (epkgs:
      (with epkgs; [
        elixir-mode
        direnv
        use-package
        use-package-chords
        magit
        company
        company-lsp
        flycheck
        es-mode
        ivy
        elpy
        rg
        vimrc-mode
        projectile
        evil
        evil-collection
        # evil-magit requires undo-tree
        undo-tree
        evil-magit
        rainbow-delimiters
        treemacs
        treemacs-evil
        treemacs-projectile
        treemacs-icons-dired
        treemacs-magit
        lsp-mode
        lsp-ui
        rustic
        auto-dim-other-buffers
        atom-one-dark-theme
        command-log-mode
        dockerfile-mode
        nix-mode
        counsel
        swiper
        yaml-mode
      ]));
  };

  home.file = {
    ".emacs.d" = {
      source = ./emacs.d;
      recursive = true;
    };
  };

  xresources.properties = {
    # Set some Emacs GUI properties in the .Xresources file because they are
    # expensive to set during initialization in Emacs lisp. This saves about
    # half a second on startup time. See the following link for more options:
    # https://www.gnu.org/software/emacs/manual/html_node/emacs/Fonts.html#Fonts
    "Emacs.menuBar" = false;
    "Emacs.toolBar" = false;
    "Emacs.verticalScrollBars" = false;
    "Emacs.Font" =
      "-CYEL-Iosevka-normal-normal-normal-*-18-*-*-*-d-0-iso10646-1";
  };

  # Home manager's emacs service doesn't provide a desktop entry for the emacs
  # client. Note the %F on the `Exec=` line passes any file name string to tell
  # emacs to open a file. I just use Albert to launch the emacs client so I
  # don't every really need that.
  xdg.dataFile."applications/emacsclient.desktop".text = ''
    [Desktop Entry]
    Name=Emacsclient
    GenericName=Text Editor
    Comment=Edit text
    MimeType=text/english;text/plain;text/x-makefile;text/x-c++hdr;text/x-c++src;text/x-chdr;text/x-csrc;text/x-java;text/x-moc;text/x-pascal;text/x-tcl;text/x-tex;application/x-shellscript;text/x-c;text/x-c++;
    Exec=emacsclient -c -a emacs %F
    Icon=emacs
    Type=Application
    Terminal=false
    Categories=Development;TextEditor;
    StartupWMClass=Emacs
    Keywords=Text;Editor;
  '';
}

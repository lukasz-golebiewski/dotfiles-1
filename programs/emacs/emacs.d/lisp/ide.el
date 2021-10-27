;; All the packages that turn emacs into a full-blown IDE with code completion, linting, etc.

(use-package company
  :commands company-tng-configure-default
  :custom
  ;; delay to start completion
  (company-idle-delay 0)
  ;; nb of chars before triggering completion
  (company-minimum-prefix-length 1)

  :config
  ;; enable company-mode in all buffers
  (global-company-mode)

  :bind
  ;; use <C> instead of <M> to navigate completions
  (:map company-active-map
	      ("M-n" . nil)
	      ("M-p" . nil)
	      ("C-n" . #'company-select-next)
	      ("C-p" . #'company-select-previous)))

(use-package projectile
  :commands projectile-mode
  :init
  (projectile-mode +1)
  ;; :config
  ;; (counsel-projectile-mode)
  :bind
  (:map projectile-mode-map
        ;; Not sure I want to use Super in emacs, since I use it a lot in gnome
        ;; ("s-p" . projectile-command-map)
        ("C-c p" . projectile-command-map)))

(use-package counsel-projectile
  :init (counsel-projectile-mode +1))

(use-package lsp-mode
  :commands lsp
  :diminish lsp-mode
  :hook
  (elixir-mode . lsp-deferred)
  (rjsx-mode . lsp-deferred)
  :init
  (setq lsp-keymap-prefix "C-c l")
  (add-to-list 'exec-path "/home/little-dude/.elixir-ls")
  :config
  (lsp-enable-which-key-integration t))

(use-package rjsx-mode
  :mode ("\\.js$" . rjsx-mode)
  :interpreter ("node" . rjsx-mode)
  :config
  (setq js-indent-level 2))

(use-package typescript-mode
  :mode "\\.tsx?$"
  :interpreter ("node" . typescript-mode)
  :hook
  (typescript-mode . prettier-mode)
  (typescript-mode . web-mode)
  (typescript-mode . lsp-deferred)
  :config
  (setq typescript-indent-level 2))

(use-package web-mode
  :mode
  "\\.html\\'"
  ;; Better not to specify this mode for the other filetypes, but
  ;; rather start web-mode with a hook, since we can have only one
  ;; entry per filetype in the auto-amode-list
  ;;
  ;; For instance we start web-mode from the typescript-mode
  ;;
  ;; ("\\.ejs\\'" "\\.hbs\\'" "\\.html\\'" "\\.php\\'" "\\.[jt]sx?\\'")
  :config
  (setq web-mode-content-types-alist '(("jsx" . "\\.[jt]sx?\\'")))
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-script-padding 2)
  (setq web-mode-block-padding 2)
  (setq web-mode-style-padding 2)
  (setq web-mode-enable-auto-pairing t)
  (setq web-mode-enable-auto-closing t)
  (setq web-mode-enable-current-element-highlight t))

(use-package prettier
  :hook
  (rjsx-mode . prettier-mode))

(use-package lsp-ui
  :commands lsp-ui-mode)

(use-package flycheck
  :commands global-flycheck-mode
  :init
  (setq flycheck-mode-globals '(not rust-mode rustic-mode))
  (global-flycheck-mode))

(use-package mix
  :hook
  (elixir-mode-hook . mix-minor-mode))

(use-package yang-mode)

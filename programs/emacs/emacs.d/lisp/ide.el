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

(use-package lsp-mode
  :commands lsp
  :diminish lsp-mode
  :hook
  (elixir-mode . lsp)
  :init
  (add-to-list 'exec-path "/home/little-dude/.elixir-ls"))

(use-package lsp-ui
  :commands lsp-ui-mode)

(use-package company-lsp
  :commands company-lsp
  :config (push 'company-lsp company-backends))

(use-package flycheck
  :commands global-flycheck-mode
  :init
  ;; (setq flycheck-mode-globals '(not rust-mode))
  (global-flycheck-mode))

(use-package mix
  :hook
  (elixir-mode-hook . mix-minor-mode))

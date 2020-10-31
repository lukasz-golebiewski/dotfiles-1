(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

(eval-when-compile
  (require 'use-package))

(load-file "~/.emacs.d/lisp/ui.el")
(load-file "~/.emacs.d/lisp/evil.el")
(load-file "~/.emacs.d/lisp/edit.el")
(load-file "~/.emacs.d/lisp/ide.el")
(load-file "~/.emacs.d/lisp/git.el")

(use-package yaml-mode
  :mode ("\\.ya?ml$" . yaml-mode))

(use-package direnv
  :config (direnv-mode))

(use-package nix-mode
  :mode "\\.nix\\'")

(use-package dockerfile-mode
  :config (add-to-list 'auto-mode-alist '("Dockerfile\\'" . dockerfile-mode)))

;; Allows to see which commands are being called:
;; - command-log-mode
;; - clm/open-command-log-buffer
(use-package command-log-mode)

(use-package rustic
  :config
  (setq rustic-lsp-server 'rust-analyzer)
  (unbind-key "C-c C-c C-t" rustic-mode-map)
  ;; when passing custom test args with rustic-test-arguments, we need
  ;; to run rustic-cargo-test-rerun instead of rustic-cargo-test
  ;;
  ;; To pass custom test args, add this to .dir-locals.el:
  ;; ((rustic-mode . ((rustic-test-arguments . "-- --skip integration"))))
  :bind (("C-c C-c C-t" . rustic-cargo-test-rerun)))

(use-package es-mode
  :init (add-to-list 'auto-mode-alist '("\\.es$" . es-mode))
  :hook ((es-result-mode . hs-minor-mode)))

(use-package elpy
  :commands elpy-enable
  ;; Only call `elpy-enable` when needed.
  ;; See: https://emacs.stackexchange.com/q/10065/22105
  :init (with-eval-after-load 'python (elpy-enable))
  :config
  (setq elpy-rpc-virtualenv-path 'current)
  ;; by default, elpy uses flymake. This forces it to use flycheck instead
  ;; See:
  ;;     - https://github.com/jorgenschaefer/elpy/wiki/Customizations#use-flycheck-instead-of-flymake
  ;;     - https://github.com/jorgenschaefer/elpy/issues/137
  (when (require 'flycheck nil t)
    (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
    (add-hook 'elpy-mode-hook 'flycheck-mode)))

(use-package rg
  :config (rg-enable-default-bindings))

(use-package sql
  :config
  ;; with mariadb, the default regexp used to match the prompt is a bit off. This fixes it.
  (sql-set-product-feature 'mysql :prompt-regexp "^\\(MariaDB\\|MySQL\\) \\[[_a-zA-Z]*\\]> "))

;; from https://stackoverflow.com/a/24659949/1836144 see also
;; https://emacs.stackexchange.com/questions/13214/automatically-formatting-sql-code
(defun sql-indent-string ()
  "Indent the string under the cursor as SQL."
  (interactive)
  (save-excursion
    (er/mark-inside-quotes)
    (let* ((text (buffer-substring-no-properties (region-beginning) (region-end)))
           (pos (region-beginning))
           (column (progn (goto-char pos) (current-column)))
           (formatted-text (with-temp-buffer
                             (insert text)
                             (delete-trailing-whitespace)
                             (sql-indent-buffer)
                             (replace-string "\n" (concat "\n" (make-string column (string-to-char " "))) nil (point-min) (point-max))
                             (buffer-string))))
      (delete-region (region-beginning) (region-end))
      (goto-char pos)
      (insert formatted-text))))

(use-package vimrc-mode
  :init (add-to-list 'auto-mode-alist '("\\.vim\\(rc\\)?\\'" . vimrc-mode)))

(use-package undo-tree
  :init (global-undo-tree-mode))

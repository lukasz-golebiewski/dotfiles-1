;; we keep our secrets in an encrypted file.
(setq auth-sources
    '((:source "~/.config/authinfo.gpg")))

(use-package magit
  :bind (("C-x g" . magit-status))
  :config
  ;; this is a workaround for https://github.com/magit/forge/issues/87
  ;; it should be removed for emacs 27
  (setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3"
      ghub-use-workaround-for-emacs-bug nil))

(use-package evil-magit
  :after evil magit
  :config
  (evil-define-key* evil-magit-state magit-mode-map [escape] nil))

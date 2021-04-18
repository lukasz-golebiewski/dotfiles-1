;; ============================ General emacs settings ============================
;; maximize the emacs window on startup
(add-to-list 'initial-frame-alist '(fullscreen . maximized))
;; ;; Disable menu-bar, tool-bar, and scroll-bar.
;; (if (fboundp 'menu-bar-mode)
;;     (menu-bar-mode -1))
;; (if (fboundp 'tool-bar-mode)
;;     (tool-bar-mode -1))
;; (if (fboundp 'scroll-bar-mode)
;;     (scroll-bar-mode -1))

;; Disable startup screen
(setq inhibit-startup-screen t)

;; Make *scratch* buffer blank
(setq initial-scratch-message "")

;; Make window title the buffer name
(setq-default frame-title-format '("%b"))

;; customize font
;; (set-frame-font "-CYEL-Iosevka-normal-normal-normal-*-18-*-*-*-d-0-iso10646-1")

;; Display line number except for certain modes
(global-display-line-numbers-mode t) ; requires emacs 26
(dolist (mode '(message-buffer-mode-hook
                treemacs-mode-hook
                magit-status-mode-hook
                org-mode-hook
                term-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; Display column number
(column-number-mode)

;; highlight the line where the cursor is
(global-hl-line-mode +1)

;; Avoid littering the user's filesystem with backups
(setq backup-by-copying t             ; don't clobber symlinks
      backup-directory-alist
      '((".*" . "~/.emacs.d/saves/")) ; don't litter my fs tree
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)       ; use versioned backups

;; Lockfiles unfortunately cause more pain than benefit
(setq create-lockfiles nil)

;; =============================== Theme ===============================
;; (use-package gruvbox-theme :config (load-theme 'gruvbox t))
(use-package atom-one-dark-theme
  :config
  (load-theme 'atom-one-dark t)
  (custom-theme-set-faces
   'atom-one-dark
   ;; - see which face we want to customize: C-u C-x =
   ;; - describe a face: `describe-face`
   ;; - list colors: `list-colors-display`
   ;; - list of attributes we can customize: https://github.com/syl20bnr/spacemacs/tree/master/layers/%2Bthemes/theming#attributes
   ;;
   ;; The cyan is pretty terrible when working with lots of keywords with hiccup
   ;; Other things I tried:
   ;; - (:foreground "#E5C07B") a nice yellow but still a bit tiring. Could be used for something else though
   ;; - (:foreground "sienna") a maroon that is pretty warm but also quite ugly.
   '(clojure-keyword-face ((t (:foreground "seashell4" :slant italic))))
   '(rainbow-delimiters-depth-1-face ((t (:foreground "wheat"))))
   '(rainbow-delimiters-unmatched-face ((t (:background "dark gray" :foreground "red"))))))

;; we highlight the current line, but it's too pale with atom-one-dark so we override it here
(set-face-background hl-line-face "gray0")

;; colorful parenthesis
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode)
  :custom-face
  (rainbow-delimiters-unmatched-face ((t (:background "dark gray" :foreground "red"))))
  (rainbow-delimiters-depth-1-face ((t (:foreground "wheat")))))
(show-paren-mode 1)
(setq show-paren-delay 0)

;; ======================== Treemacs ========================
(use-package treemacs
  :config
  (setq treemacs-show-cursor nil)
  :bind
  (([f9] . treemacs)))

(use-package treemacs-evil
  :after treemacs evil)

(use-package treemacs-projectile
  :after treemacs projectile)

(use-package treemacs-icons-dired
  :after treemacs dired
  :config (treemacs-icons-dired-mode))

(use-package treemacs-magit
  :after treemacs magit)

;; (use-package lsp-treemacs
;;   :after treemacs lsp-mode
;;   :config (lsp-treemacs-sync-mode 1))

(use-package auto-dim-other-buffers
  :commands auto-dim-other-buffers-mode
  :diminish auto-dim-other-buffers-mode
  :init (auto-dim-other-buffers-mode))

(use-package uniquify
  :config
  (setq uniquify-buffer-name-style 'forward)
  (setq uniquify-separator "/")
  (setq uniquify-after-kill-buffer-p t)     ; rename after killing uniquified
  (setq uniquify-ignore-buffers-re "^\\*")) ; don't muck with special buffers

;; ======================== Ivy ========================
(use-package ivy
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)
  (setq ivy-initial-inputs-alist nil))

(use-package counsel
  :after ivy
  :config
  ;; by default, the regexp used by ivy starts with ^, which is
  ;; annoying. See:
  ;; https://emacs.stackexchange.com/a/38842/22105
  ;; (setcdr (assoc 'counsel-M-x ivy-initial-inputs-alist) "")
  (counsel-mode)
  :bind ((:map minibuffer-local-map ("C-r" . 'counsel-minibuffer-history))))

(use-package swiper
  :after ivy
  :bind (("C-s" . swiper)
         ("C-r" . swiper)))

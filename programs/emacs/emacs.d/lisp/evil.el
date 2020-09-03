(use-package use-package-chords
  :config
  (key-chord-mode 1)
  ;; The default value is 0.1 but it's a bit short. The problem is
  ;; that it kinda feels slow when moving with `j` or `k` if we set it
  ;; to 0.2.
  (setq key-chord-two-keys-delay 0.2))

(use-package evil
  :init
  (setq evil-want-integration t) ;; This is optional since it's already set to t by default.
  (setq evil-want-keybinding nil)
  :chords (("jk" . evil-normal-state))
  :config
  (evil-mode 1)
  ;; Use vim-like search.
  (evil-select-search-module 'evil-search-module 'evil-search)
  (define-key evil-normal-state-map "s" nil)
  (define-key evil-normal-state-map (kbd "ss") 'evil-window-split)
  (define-key evil-normal-state-map (kbd "sv") 'evil-window-vsplit)
  (define-key evil-normal-state-map (kbd "sr") 'evil-window-rotate-downwards)

  (define-key evil-normal-state-map (kbd "M-h") 'evil-window-left)
  (define-key evil-normal-state-map (kbd "M-j") 'evil-window-down)
  (define-key evil-normal-state-map (kbd "M-k") 'evil-window-up)
  (define-key evil-normal-state-map (kbd "M-l") 'evil-window-right)

  (define-key evil-normal-state-map (kbd "C-M-h") 'evil-window-move-far-left)
  (define-key evil-normal-state-map (kbd "C-M-j") 'evil-window-move-very-bottom)
  (define-key evil-normal-state-map (kbd "C-M-k") 'evil-window-move-very-top)
  (define-key evil-normal-state-map (kbd "C-M-l") 'evil-window-move-far-right)

  (define-key evil-normal-state-map (kbd "C-=") 'balance-windows)
  (define-key evil-normal-state-map (kbd "C-s z") 'delete-other-windows)

  ;; (define-key evil-normal-state-map (kbd "no") 'highlight-remove-all)
  )

;; See https://emacs.stackexchange.com/a/9584/22105
(defadvice evil-inner-word (around iw-motion activate)
  (let ((table (copy-syntax-table (syntax-table))))
    (modify-syntax-entry ?_ "w" table)
    (modify-syntax-entry ?- "w" table)
    (with-syntax-table table ad-do-it)))

(defadvice evil-forward-word-begin (around w-motion activate)
  (let ((table (copy-syntax-table (syntax-table))))
    (modify-syntax-entry ?_ "w" table)
    (modify-syntax-entry ?- "w" table)
    (with-syntax-table table ad-do-it)))

(defadvice evil-forward-word-end (around e-motion activate)
  (let ((table (copy-syntax-table (syntax-table))))
    (modify-syntax-entry ?_ "w" table)
    (modify-syntax-entry ?- "w" table)
    (with-syntax-table table ad-do-it)))

(defadvice evil-backward-word-begin (around b-motion activate)
  (let ((table (copy-syntax-table (syntax-table))))
    (modify-syntax-entry ?_ "w" table)
    (modify-syntax-entry ?- "w" table)
    (with-syntax-table table ad-do-it)))

(defadvice evil-backward-word-end (around ge-motion activate)
  (let ((table (copy-syntax-table (syntax-table))))
    (modify-syntax-entry ?_ "w" table)
    (modify-syntax-entry ?- "w" table)
    (with-syntax-table table ad-do-it)))

(defadvice evil-a-word (around a-word activate)
  (let ((table (copy-syntax-table (syntax-table))))
    (modify-syntax-entry ?_ "w" table)
    (modify-syntax-entry ?- "w" table)
    (with-syntax-table table ad-do-it)))

(defadvice evil-inner-word (around inner-word activate)
  (let ((table (copy-syntax-table (syntax-table))))
    (modify-syntax-entry ?_ "w" table)
    (modify-syntax-entry ?- "w" table)
    (with-syntax-table table ad-do-it)))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

;; For some reason, setting that in evil's `:config` doesn't work
(evil-mode 1)

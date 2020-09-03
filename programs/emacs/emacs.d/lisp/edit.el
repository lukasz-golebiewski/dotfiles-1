;; disable hard tabs
(setq-default indent-tabs-mode nil)
;; default tab width is 4, not 8
(setq-default tab-width 4)
;; make TAB actually insert a tab instead of auto-indenting the current line
;;
;; FIXME: instead of blindly inserting a tab, this should add an indentation level. For instance:
;; - with (indent-tabs-mode nil) and (tab-width 4), if the cursor is at column 6, it should insert 2 spaces
;; - with (indent-tabs-mode nil) and (tab-width 4), if the cursor is at column 4, it should insert 4 spaces
;; - with (indent-tabs-mode t) is should insert a \t
(setq-default tab-always-indent nil)
;; FIXME: RET should insert enough tabs to match the previous line's indentation

(put 'downcase-region 'disabled nil)
(add-hook 'before-save-hook 'delete-trailing-whitespace)

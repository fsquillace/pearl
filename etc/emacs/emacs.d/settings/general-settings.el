

;; ===== Automatically load abbreviations table =====
;; Note that emacs chooses, by default, the filename
;; "~/.abbrev_defs", so don't try to be too clever
;; by changing its name
;;(setq-default abbrev-mode t)
;;(read-abbrev-file "~/.abbrev_defs")
;;(setq save-abbrevs t)

;; Set font
(global-font-lock-mode t)

;; ===== Set the highlight current line minor mode =====
;; In every buffer, the line which contains the cursor will be fully
;; highlighted
(global-hl-line-mode 1)


 ;; ===== Set standard indent to 4 that is also the default value =====
(setq standard-indent 4)


;; ========== Line by line scrolling ==========
;; This makes the buffer scroll by only a single line when the up or
;; down cursor keys push the cursor (tool-bar-mode) outside the
;; buffer. The standard emacs behaviour is to reposition the cursor in
;; the center of the screen, but this can make the scrolling confusing
(setq scroll-step 1)


;; ===== Turn off tab character =====
;; Emacs normally uses both tabs and spaces to indent lines. If you
;; prefer, all indentation can be made from spaces only. To request this,
;; set `indent-tabs-mode' to `nil'. This is a per-buffer variable;
;; altering the variable affects only the current buffer, but it can be
;; disabled for all buffers.
;; Use (setq ...) to set value locally to a buffer
;; Use (setq-default ...) to set value globally
(setq tab-width 4)
(setq-default indent-tabs-mode nil) 


;; ========== Support Wheel Mouse Scrolling ==========
(mouse-wheel-mode t) 

;; ========== Show the trailing whitespace =========
(setq show-trailing-whitespace 1)

;; ========== Prevent Emacs from making backup files ==========
;;(setq make-backup-files nil) 


;; ========== Place Backup Files in Specific Directory ==========
;; Enable backup files.
(setq make-backup-files t)
;; Enable versioning with default values (keep five last versions, I think!)
(setq version-control t)
;; Save all backup file in this directory.
(setq backup-directory-alist `(("." . ,(concat user-emacs-directory
                                                 "backups/"))))

;; ========== Place Auto-Save Files in Specific Directory ==========
(setq auto-save-file-name-transforms
           `((".*" ,(concat user-emacs-directory
                                                 "auto-save/") t)))
(setq auto-save-list-file-prefix
         (concat user-emacs-directory
                                                 "auto-save/"))

;; ========== Enable Line and Column Numbering ==========
;; Show line-number in the mode line
(line-number-mode 1)
;; Show column-number in the mode line
(column-number-mode 1)
(global-linum-mode 1)


;; ========== Set the fill column ==========
;; Enable backup files.
(setq-default fill-column 79)


;; ===== Language =====
(setq current-language-environment "English")


;; =====  Don't show the startup screen =====
(setq inhibit-startup-screen 1)
(setq inhibit-splash-screen 1)



;; ===== Don't show stuffs =====
;;(menu-bar-mode nil)
;;(require 'tool-bar)
;;(tool-bar-mode nil)
;;(scroll-bar-mode nil)


;; ===== don't blink the cursor =====
;;(blink-cursor-mode nil)


;; ===== Turn on Auto Fill mode automatically in all modes =====
;; Auto-fill-mode the the automatic wrapping of lines and insertion of
;; newlines when the cursor goes over the column limit.
;; This should actually turn on auto-fill-mode by default in all major
;; modes. The other way to do this is to turn on the fill for specific modes
;; via hooks.
(setq auto-fill-mode 1)


;; ===== Make Org mode the default mode for new buffers =====
(setq default-major-mode 'org-mode)


;; ===== Key bindings =====
(global-set-key (kbd "M-/") 'hippie-expand)
(global-set-key (kbd "C-x C-b") 'ibuffer)

(global-set-key (kbd "C-s") 'isearch-forward-regexp)
(global-set-key (kbd "C-r") 'isearch-backward-regexp)
(global-set-key (kbd "C-M-s") 'isearch-forward)
(global-set-key (kbd "C-M-r") 'isearch-backward)


;; ===== highlights the matching pair when the point is over parentheses =====
(require 'paren)
(show-paren-mode 1)


;; ===== Under X, uses X clipboard  =====
(setq x-select-enable-clipboard t
        x-select-enable-primary t
        save-interprogram-paste-before-kill t)

;; ===== Apropos commands perform more extensive searches than default =====
(setq apropos-do-all t)

;; ===== Mouse yanking inserts at the point instead of the location of the click =====
(setq mouse-yank-at-point t)


(provide 'general-settings)

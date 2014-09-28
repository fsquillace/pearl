
;; -*- mode: elisp -*-

;;(setq pearl-path-settings (concat (getenv "PEARL_ROOT") "/etc/emacs/emacs.d/settings"))
;;(setq pearl-path-plugins (concat (getenv "PEARL_ROOT") "/etc/emacs/emacs.d/plugins"))

;; Path where settings and plugins are kept
(setq pearl-path-settings (expand-file-name "emacs.d/settings"
    (file-name-directory load-file-name)))
(setq pearl-path-plugins (expand-file-name "emacs.d/plugins"
    (file-name-directory load-file-name)))

;; path where settings files are kept
(add-to-list 'load-path pearl-path-settings)

;; global config variables
;; load the folder plugin
(setq plugin-path pearl-path-plugins)
;; load the single file plugin
(add-to-list 'load-path pearl-path-plugins)


;; General settings
(require 'general-settings)

;; Ido mode
(require 'ido-settings)

;; auto complete
(require 'auto-complete-settings)

;; colour settings
(require 'theme-settings)

;; save place
(require 'saveplace-settings)

;; uniquify
(require 'uniquify-settings)

;; fill column
(require 'fill-column-indicator-settings)

;; org-mode
(require 'org-mode-settings)

;; undo-tree
(require 'undo-tree-settings)

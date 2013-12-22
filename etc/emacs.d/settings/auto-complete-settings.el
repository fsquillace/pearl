
(add-to-list 'load-path (concat pearl-path-plugins "/auto-complete"))
(require 'auto-complete)
(add-to-list 'ac-dictionary-directories (concat user-emacs-directory "ac-dict"))
(require 'auto-complete-config)
(ac-config-default)
(global-auto-complete-mode t)


(provide 'auto-complete-settings)

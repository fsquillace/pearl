
(add-to-list 'load-path (concat pearl-path-plugins "/fill-column-indicator"))
(require 'fill-column-indicator)

(define-globalized-minor-mode global-fci-mode fci-mode (lambda () (fci-mode 1)))
(global-fci-mode 1)

;;(setq fci-rule-width 1)
;;(setq fci-rule-color "darkblue")

(provide 'fill-column-indicator-settings)

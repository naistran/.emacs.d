;;; -*- lexical-binding: t -*-

(with-eval-after-load 'html-mode
  (define-key html-mode-map (kbd "RET") 'newline-and-indent))

(provide 'p-html)

;;; p-html.el ends here

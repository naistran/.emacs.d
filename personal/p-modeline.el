;;; -*- lexical-binding: t -*-

(p-require-package 'diminish)

(require 'diminish)

(--each '(elisp-slime-nav
          highlight-parentheses
          eldoc
          paredit
          undo-tree
          auto-complete
          git-gutter
          redshank
          projectile
          smartparens
          ruby-tools
          ruby-end
          robe)
  (eval-after-load it
    `(diminish ',(-> it
                   (symbol-name)
                   (concat "-mode")
                   (intern)))))

(eval-after-load 'yasnippet
  '(diminish 'yas-minor-mode))

(eval-after-load 'rinari
  '(progn
     (diminish 'rinari-minor-mode)))

(provide 'p-modeline)

;;; p-modeline.el ends here
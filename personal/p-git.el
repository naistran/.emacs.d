;;; -*- lexical-binding: t -*-

(p-require-package 'magit 'melpa)
(p-require-package 'git-rebase-mode 'melpa)
(p-require-package 'git-commit-mode 'melpa)
(p-require-package 'gitconfig-mode)
(p-require-package 'gitignore-mode)
(p-require-package 'git-gutter 'melpa)
(p-require-package 'git-gutter-fringe 'melpa)

(require 'p-evil)
(require 'p-leader)
(require 'git-gutter-fringe)

(defun p-insert-git-cd-number ()
  (-when-let (project-number
              (car (s-match "CD-[0-9]+"
                            (shell-command-to-string
                             "git symbolic-ref --short HEAD"))))
    (when (and (bolp) (eolp)) (insert project-number " "))))

(defadvice magit-status (around magit-fullscreen activate)
  (window-configuration-to-register :magit-fullscreen)
  ad-do-it
  (delete-other-windows))

(defun p-magit-quit-session ()
  "Restores the previous window configuration and kills the magit buffer"
  (interactive)
  (kill-buffer)
  (jump-to-register :magit-fullscreen))

(defun p-magit-toggle-whitespace ()
  (interactive)
  (if (member "-w" magit-diff-options)
      (p-magit-dont-ignore-whitespace)
    (p-magit-ignore-whitespace)))

(defun p-magit-ignore-whitespace ()
  (interactive)
  (add-to-list 'magit-diff-options "-w")
  (magit-refresh))

(defun p-magit-dont-ignore-whitespace ()
  (interactive)
  (setq magit-diff-options (remove "-w" magit-diff-options))
  (magit-refresh))

(add-hook 'git-commit-mode-hook 'p-insert-git-cd-number)

(global-git-gutter-mode 1)

(setq git-gutter:disabled-modes '(ediff-mode))

;;;;;;;;;;;;;;
;; Bindings ;;
;;;;;;;;;;;;;;

(defadvice magit-blame-mode (after switch-to-emacs-mode activate)
  (if magit-blame-mode
      (evil-emacs-state 1)
    (evil-normal-state 1)))

(global-set-key (kbd "C-x v =") 'git-gutter:popup-hunk)
(global-set-key (kbd "C-x v p") 'git-gutter:previous-hunk)
(global-set-key (kbd "C-x v n") 'git-gutter:next-hunk)
(global-set-key (kbd "C-x v r") 'git-gutter:revert-hunk)

(p-set-leader-key
  "m" 'magit-blame-mode
  "g" 'magit-status
  "G" 'git-gutter)

(evil-add-hjkl-bindings magit-status-mode-map 'emacs
  "K" 'magit-discard-item
  "V" 'magit-revert-item
  "v" 'set-mark-command
  "l" 'magit-key-mode-popup-logging
  "h" 'magit-key-mode-popup-diff-options
  "q" 'p-magit-quit-session
  "W" 'p-magit-toggle-whitespace
  ":" 'magit-git-command
  (kbd "C-n") 'magit-goto-next-section
  (kbd "C-p") 'magit-goto-previous-section)

(evil-add-hjkl-bindings magit-log-mode-map 'emacs
  "V" 'magit-revert-item
  "l" 'magit-key-mode-popup-logging
  "h" 'magit-log-toggle-margin
  "/" 'evil-search-forward
  "?" 'evil-search-backward
  "n" 'evil-search-next
  "N" 'evil-search-previous
  (kbd "C-n") 'magit-goto-next-section
  (kbd "C-p") 'magit-goto-previous-section)

(evil-add-hjkl-bindings magit-commit-mode-map 'emacs
  "V" 'magit-revert-item
  "v" 'set-mark-command
  "l" 'magit-key-mode-popup-logging
  "h" 'magit-key-mode-popup-diff-options
  (kbd "C-n") 'magit-goto-next-section
  (kbd "C-p") 'magit-goto-previous-section)

(evil-add-hjkl-bindings magit-branch-manager-mode-map 'emacs
  "K" 'magit-discard-item)

(add-to-list 'evil-emacs-state-modes 'git-rebase-mode)
(add-to-list 'evil-insert-state-modes 'git-commit-mode)
(evil-add-hjkl-bindings magit-blame-map)
(evil-add-hjkl-bindings git-rebase-mode-map 'emacs
  "K" 'git-rebase-kill-line)

(provide 'p-git)

;;; p-git.el ends here

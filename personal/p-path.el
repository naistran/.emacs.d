;;; -*- lexical-binding: t -*-

(unless (eq system-type 'windows-nt)
  (defun p-path-from-file (fpath)
    "Reads a :-delineated path file and adds
it to exec-path and the PATH variable"
    (when (file-exists-p fpath)
      (with-temp-buffer
        (insert-file-contents fpath)
        (setq exec-path
              (append (-map (lambda (s)
                              (s-trim (s-replace "$HOME" (expand-file-name "~") s)))
                            (split-string (buffer-string) ":" t))
                      exec-path))
        (setenv "PATH" (mapconcat 'identity exec-path ":")))))
  (defun p-update-path ()
    (interactive)
    (p-path-from-file "~/.path"))

  (p-update-path))





(provide 'p-path)

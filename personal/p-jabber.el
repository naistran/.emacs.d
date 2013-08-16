(p-require-package 'jabber)

(defvar p-hipchat-account-number "2002")
(defvar p-hipchat-user-number "397595")
(defvar p-hipchat-rooms
  '(("Dev Chatter" . "dev")
    ("Dev New Hire" . "dev_new_hire")
    ("Dev Sustaining" . "dev_sustaining")
    ("Dev Work" . "product_team")))

(defun p-hipchat-connect ()
  (interactive)
  (let ((server "chat.hipchat.com"))
    (unless (ignore-errors (jabber-read-account))
      (jabber-connect
       (s-concat p-hipchat-account-number "_"
                 p-hipchat-user-number)
       server nil nil
       (p-password 'hipchat-password)
       server 5223 'ssl))))

(defun p-hipchat-join ()
  (interactive)
  (unless (ignore-errors (jabber-read-account))
    (error "Not connected to hipchat."))
  (--each (-map 'cdr p-hipchat-rooms)
    (jabber-groupchat-join
     (jabber-read-account)
     (s-concat p-hipchat-account-number "_" it "@conf.hipchat.com")
     "Emanuel Evans")))

(defun p-hipchat-switch-to-room ()
  (interactive)
  (let* ((chatrooms (-map 'car p-hipchat-rooms))
         (room
          (completing-read "Room: " chatrooms nil nil nil nil (car chatrooms))))
    (let ((buffer-regexp
           (-> room
             (assoc p-hipchat-rooms)
             (cdr)
             (s-concat "@"))))
      (switch-to-buffer
       (car
        (--filter (s-matches? buffer-regexp (buffer-name it))
                  (buffer-list)))))))

(global-set-key (kbd "C-c h") 'p-hipchat-switch-to-room)



(provide 'p-jabber)

;;; p-jabber.el ends here
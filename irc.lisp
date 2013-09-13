(in-package #:lbnc)

(defun create-irc-connection (client nickname)
  (let ((uid (write-to-string (setf *uids* (1+ *uids*))))
        (conn (cl-irc:connect :nickname nickname
                              ; Test server: ngircd works nicely.
                              :server "127.0.0.1")))
    (add-user uid client conn)
    (bt:make-thread (lambda ()
                      (cl-irc:read-message-loop conn))
                    :name (concatenate 'string "IRC " uid))
    uid))

(defun add-privmsg-hook (uid)
  (let ()
    (lambda (message)
      (write-to-client-text (get-client uid)
                            (format nil "~A" message)))))

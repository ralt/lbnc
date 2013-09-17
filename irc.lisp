(in-package #:lbnc)

(defun create-irc-connection (client nickname)
  (let ((uid (format nil "~A" (uuid:make-v4-uuid)))
        (conn (cl-irc:connect :nickname nickname
                              ; Test server: ngircd works nicely.
                              :server "127.0.0.1"
                              :port 6668)))
    (add-user uid client conn)
    (bt:make-thread (lambda ()
                      (cl-irc:read-message-loop conn))
                    :name (concatenate 'string "IRC " uid))
    uid))

(defun add-privmsg-hook (uid)
  (let ()
    (lambda (message)
      (let ((ret (make-string-output-stream)))
        (json:encode-json `((:source . ,(cl-irc:source message))
                            (:time . ,(cl-irc:received-time message))
                            (:args . ,(cl-irc:arguments message)))
                          ret)
        (write-to-client-text (get-client uid)
                              (concatenate 'string
                                           "privmsg "
                                           (get-output-stream-string ret)))))))

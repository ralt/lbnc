(in-package #:lbnc)

(defun create-irc-connection (client nickname)
  (let ((uid (format nil "~A" (uuid:make-v4-uuid)))
        (conn (cl-irc:connect :nickname nickname
                              :server "localhost"
                              :port 6667)))
    (add-user uid client conn)))

(defun add-privmsg-hook (uid)
  (let ()
    (lambda (message)
      (let ((ret (make-string-output-stream)))
        (json:encode-json `((:source . ,(cl-irc:source message))
                            (:time . ,(cl-irc:received-time message))
                            (:args . ,(cl-irc:arguments message)))
                          ret)
        (clws:write-to-client-text (get-client uid)
                              (concatenate 'string
                                           "privmsg "
                                           (get-output-stream-string ret)))))))

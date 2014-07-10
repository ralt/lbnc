(in-package #:lbnc)

(defcommand "connect" (client uid rest)
  (declare (ignorable uid))
  (let* ((new-uid (create-irc-connection client rest))
         (conn (get-connection new-uid)))
    (cl-irc:add-hook conn
                     'cl-irc:irc-privmsg-message
                     (add-privmsg-hook new-uid))
    (bt:make-thread #'(lambda ()
                        (cl-irc:read-message-loop conn)))
    (clws:write-to-client-text client (concatenate 'string
                                                   "new-uid "
                                                   new-uid))))

(defcommand "join" (client uid rest)
  (declare (ignorable client))
  (cl-irc:join (get-connection uid) rest))

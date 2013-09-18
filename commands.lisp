(in-package #:lbnc)

(defcommand "connect" (client uid rest)
  (declare (ignorable uid))
  (let ((new-uid (create-irc-connection client rest)))
    (write-to-client-text client (concatenate 'string
                                              "new-uid "
                                              new-uid))
    (cl-irc:add-hook (get-connection new-uid)
                     'cl-irc:irc-privmsg-message
                     (add-privmsg-hook new-uid))))

(defcommand "join" (client uid rest)
  (declare (ignorable client))
  (cl-irc:join (get-connection uid) rest))

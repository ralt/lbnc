(in-package #:lbnc)

(bt:make-thread (lambda ()
                  (run-server 1102))
                :name "WebSocket server")

(defclass chat-resource (ws-resource)
  ())

(defmethod resource-client-connected ((res chat-resource) client)
  t)

(defmethod resource-client-disconnected ((res chat-resource) client)
  t)

(defmethod resource-received-text ((res chat-resource) client message)
  (let* ((elts (split-sequence:split-sequence #\Space message))
         (uid (pop elts))
         (command (pop elts))
         ; "String.join"
         (rest (format nil "~{~A~^ ~}" elts)))
    (cond
      ((string= command "connect")
       (let ((new-uid (create-irc-connection client rest)))
         (write-to-client-text client new-uid)
         (cl-irc:add-hook (get-connection new-uid)
                          'cl-irc:irc-privmsg-message
                          (add-privmsg-hook new-uid))))
      ((string= command "join") (cl-irc:join (get-connection uid) rest)))))

(register-global-resource "/chat"
                          (make-instance 'chat-resource)
                          (origin-prefix "http://127.0.0.1" "http://localhost"))

(bt:make-thread (lambda ()
                  (run-resource-listener
                   (find-global-resource "/chat")))
                :name "Chat resource listener")

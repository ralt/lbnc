(in-package #:lbnc)

(bt:make-thread (lambda ()
                  (clws:run-server 1102))
                :name "WebSocket server")

(defclass chat-resource (clws:ws-resource)
  ())

(defmethod resource-client-connected ((res chat-resource) client))

(defmethod resource-client-disconnected ((res chat-resource) client))

(defmethod resource-received-text ((res chat-resource) client message)
  (let* ((elts (split-sequence:split-sequence #\Space message))
         (uid (pop elts))
         (command (pop elts))
         (rest (format nil "~{~A~^ ~}" elts)))
    (cond
      ((string= command "connect")
       (clws:write-to-client-text client
                                  (create-irc-connection rest)))
      ((string= command "join") (cl-irc:join (gethash uid *connections*) rest)))))

(defun create-irc-connection (nickname)
  (let ((uid (format nil "~A" (uuid:make-v4-uuid)))
        (conn (cl-irc:connect :nickname nickname
                              :server "irc.freenode.net")))
    (setf (gethash uid *connections*) conn)
    (bt:make-thread (lambda ()
                      (cl-irc:read-message-loop conn)))
    uid))

(clws:register-global-resource "/chat"
                          (make-instance 'chat-resource)
                          (clws:origin-prefix "http://127.0.0.1" "http://localhost"))

(bt:make-thread (lambda ()
                  (clws:run-resource-listener
                   (clws:find-global-resource "/chat")))
                :name "Chat resource listener")

(in-package #:lbnc)

(defparameter *commands* (make-hash-table :test 'equal))

(bt:make-thread (lambda ()
                  (clws:run-server 1102))
                :name "WebSocket server")

(defclass chat-resource (clws:ws-resource)
  ())

(defmethod resource-client-connected ((res chat-resource) client)
  t)

(defmethod resource-client-disconnected ((res chat-resource) client)
  t)

(defmacro defcommand (command args &body body)
  `(setf (gethash ,command *commands*) #'(lambda ,args
                                           ,@body)))

(defmethod resource-received-text ((res chat-resource) client message)
  (let* ((elts (split-sequence:split-sequence #\Space message))
         (uid (pop elts))
         (command (pop elts))
         ; "String.join"
         (rest (format nil "~{~A~^ ~}" elts)))
    (funcall (gethash command *commands*) client uid rest)))

(clws:register-global-resource "/chat"
                          (make-instance 'chat-resource)
                          (clws:origin-prefix "http://localhost:1101"))

(bt:make-thread (lambda ()
                  (clws:run-resource-listener
                   (clws:find-global-resource "/chat")))
                :name "Chat resource listener")

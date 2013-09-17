(in-package #:lbnc)

(defparameter *commands* (make-hash-table :test 'equal))

(bt:make-thread (lambda ()
                  (run-server 1102))
                :name "WebSocket server")

(defclass chat-resource (ws-resource)
  ())

(defmethod resource-client-connected ((res chat-resource) client)
  t)

(defmethod resource-client-disconnected ((res chat-resource) client)
  t)

(defmacro defcommand (command &body body)
  `(setf (gethash ,command *commands*) #'(lambda (uid rest)
                                           ,@body)))

(defmethod resource-received-text ((res chat-resource) client message)
  (let* ((elts (split-sequence:split-sequence #\Space message))
         (uid (pop elts))
         (command (pop elts))
         ; "String.join"
         (rest (format nil "~{~A~^ ~}" elts)))
    (funcall (gethash command *commands*) uid rest)))

(register-global-resource "/chat"
                          (make-instance 'chat-resource)
                          (origin-prefix "http://vm.margaine.com:1101"))

(bt:make-thread (lambda ()
                  (run-resource-listener
                   (find-global-resource "/chat")))
                :name "Chat resource listener")

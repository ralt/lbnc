(in-package #:lbnc)

(defparameter *commands* (make-hash-table :test 'equal))

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

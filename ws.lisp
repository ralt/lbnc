(in-package #:lbnc)

(bt:make-thread (lambda ()
                  (run-server 1102))
                :name "WebSocket server")

(defclass chat-resource (ws-resource)
  ())

(defmethod resource-client-connected ((res chat-resource) client)
  t)

(defmethod resource-client-disconnected ((res chat-resource) client))

(defmethod resource-received-text ((res chat-resource) client message)
  (write-to-client-text client (reverse message)))

(defmethod resource-received-binary((res chat-resource) client message)
  (write-to-client-binary client message))

(register-global-resource "/chat"
                          (make-instance 'chat-resource)
                          (origin-prefix "http://127.0.0.1" "http://localhost"))

(bt:make-thread (lambda ()
                  (run-resource-listener
                   (find-global-resource "/chat")))
                :name "Chat resource listener")

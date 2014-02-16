(in-package #:lbnc)

;; Start the web server
(hunchentoot:start (make-instance 'hunchentoot:easy-acceptor :port 1101))

;; The websocket server
(bt:make-thread (lambda ()
                  (clws:run-server 1102))
                :name "WebSocket server")

(clws:register-global-resource "/chat"
                          (make-instance 'chat-resource)
                          (clws:origin-prefix "http://localhost:1101"))

;; The websocket resource
(bt:make-thread (lambda ()
                  (clws:run-resource-listener
                   (clws:find-global-resource "/chat")))
                :name "Chat resource listener")

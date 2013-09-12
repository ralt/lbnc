(in-package #:lbnc)

;; Start the web server
(start (make-instance 'easy-acceptor :port 1101))

;; Static folder
(push (create-folder-dispatcher-and-handler "/static/" "static/")
      *dispatch-table*)

(define-easy-handler (home :uri "/") ()
  (redirect "/chat"))

(define-easy-handler (chat :uri "/chat") ()
    (page "Chat window"
      (:div :id "messages" :class "messages")
      (:div :class "input"
        (:textarea :rows "3")
        (:input :type "submit" :value "Envoyer"))
      (:template :id "message"
        (:div :class "message"
          (:div :class "nickname")
          (:div :class "text")))))

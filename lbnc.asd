;;;; lbnc.asd

(asdf:defsystem #:lbnc
  :serial t
  :description "Lisp IRC Bouncer"
  :author "Florian Margaine <florian@margaine.com>"
  :license "GPL License"
  :depends-on ("hunchentoot"
               "cl-who"
               "clws"
               "bordeaux-threads"
               "cl-irc"
               "uuid"
               "cl-log"
               "cl-json")
  :components ((:file "package")
               (:file "logger")
               (:file "users")
               (:file "http")
               (:file "ws")
               (:file "commands")
               (:file "irc")
               (:file "lbnc")))

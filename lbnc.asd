;;;; lbnc.asd

(asdf:defsystem #:lbnc
  :serial t
  :description "Lisp IRC Bouncer"
  :author "Florian Margaine <florian@margaine.com>"
  :license "GPL License"
  :depends-on ("hunchentoot" "cl-who" "clws" "bordeaux-threads")
  :components ((:file "package")
               (:file "web")
               (:file "lbnc")))

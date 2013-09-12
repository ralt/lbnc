;;;; package.lisp

(defpackage #:lbnc
  (:use #:cl #:hunchentoot #:clws))

(setf cl-who:*prologue* "<!doctype html>")

(defmacro page (title &body body)
  `(who:with-html-output-to-string (*standard-output* nil :prologue t)
     (:html
      (:head
       (:meta :charset "utf-8")
       (:title ,title)
       (:link :rel "stylesheet" :href "static/css/style.css")
       (:script :src "static/js/script.js"))
      (:body
       ,@body))))

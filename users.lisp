(in-package #:lbnc)

(defparameter *users* (make-hash-table :test 'equal))

(defun get-connection (uid)
  (nth 1 (gethash uid *users*)))

(defun get-client (uid)
  (nth 0 (gethash uid *users*)))

(defun add-user (uid client connection)
  (setf (gethash uid *users*) (list client connection))
  uid)

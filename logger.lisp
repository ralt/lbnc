(in-package #:lbnc)

(setf (cl-log:log-manager) (make-instance 'cl-log:log-manager
                                         :message-class 'cl-log:formatted-message))

(cl-log:start-messenger 'cl-log:text-file-messenger
                        :filename "log.txt")

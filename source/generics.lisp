(cl:in-package #:pantalea.networking)


(defgeneric connect! (networking destination &optional event))
(defgeneric disconnect! (networking connection &optional event))
(defgeneric start! (networking &optional event))
(defgeneric stop! (networking &optional event))
(defgeneric destination (connection))
(defgeneric connection (networking destination))
(defgeneric send (networking connection data))

(defgeneric notify-incoming-data (listener networking connection data))
(defgeneric attach-on-incoming-data! (networking listener))

(cl:in-package #:pantalea.networking)


(defgeneric connect! (networking destination &optional promise))
(defgeneric disconnect! (networking connection &optional promise))
(defgeneric start! (networking))
(defgeneric stop! (networking))
(defgeneric destination (connection))
(defgeneric connection (networking destination))
(defgeneric send (networking connection data))

(defgeneric notify-incoming-data (listener networking connection data))
(defgeneric attach-on-incoming-data! (networking listener))

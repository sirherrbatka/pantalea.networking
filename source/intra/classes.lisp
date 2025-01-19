(cl:in-package #:pantalea.networking.intra)


(defclass transport (protocol:fundamental-transport)
  ())

(defclass connection (protocol:fundamental-connection)
  ((%destination
    :initarg :destination
    :reader destination)))

(defclass destination (protocol:fundamental-destination)
  ((%key
    :initarg :key
    :accessor key)))

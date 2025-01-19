(cl:defpackage #:pantalea.networking
  (:use #:cl #:iterate)
  (:import-from #:serapeum
                #:vect)
  (:export
   #:fundamental-transport
   #:fundamental-destination
   #:fundamental-connection
   #:notify-incoming-data
   #:send*
   #:send
   #:initialize-connection
   #:make-connection))

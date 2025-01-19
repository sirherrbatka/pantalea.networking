(cl:defpackage #:pantalea.networking
  (:use #:cl #:iterate)
  (:import-from #:serapeum
                #:vect)
  (:export
   #:fundamental-transport
   #:fundamental-destination
   #:fundamental-connection
   #:notify-incoming-data
   #:incoming-data-listeners
   #:incoming-data-processors
   #:outgoing-data-processors
   #:process-incoming-data
   #:process-outgoing-data
   #:send*
   #:send
   #:initialize-connection
   #:make-connection))

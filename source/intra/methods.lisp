#|
Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

1) Redistributions of source code must retain the above copyright notice, this
list of conditions and the following disclaimer.

2) Redistributions in binary form must reproduce the above copyright notice,
this list of conditions and the following disclaimer in the documentation and/or
other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
|#

(cl:in-package #:pantalea.networking.intra)


(defmethod protocol:make-connection ((transport transport)
                                     (destination destination))
  (bind ((key (key destination))
         ((:values result found) (gethash key *connections*)))
    (unless found
      (errors:!!! protocol:cant-connect ("Connection for key ~a not found" key)))
    (make-instance 'connection :destination result)))

(defmethod protocol:connection ((transport transport) (destination destination))
  (or (gethash (key destination) (connections transport))
      (errors:!!! protocol:connection-not-found
                  ("Connection not found for destination ~a" destination))))

(defmethod protocol:connect! ((transport transport)
                              (destination destination))
  (let ((result (protocol:make-connection transport destination)))
    (event-loop:start! result)
    (setf (gethash (key destination) (connections transport)) result)
    (event-loop:events-sequence result
        ((protocol:$connection$
          ()
          (handler-case
              (progn
                (protocol:initialize-connection/all-initializers transport result)
                result)
            (error (e)
              (remhash (key destination) (connections transport))
              (error e))))))
    result))

(defmethod protocol:send* (networking (connection connection) data)
  (let ((destination (destination connection)))
    (pantalea.event-loop:add! destination
                              (make-react networking destination data))))

(defmethod react ((connection connection) data)
  (iterate
    (with data = (protocol:process-incoming-data/all-processors connection data))
    (with transport = (protocol:transport connection))
    (for listener in-vector (protocol:incoming-data-listeners connection))
    (ignore-errors (protocol:notify-incoming-data listener
                                                  transport
                                                  connection
                                                  data))))

(defmethod protocol:transport-name ((object connection))
  :pantalea.networking.intra)

(defmethod protocol:transport-name ((object transport))
  :pantalea.networking.intra)

(defmethod protocol:transport-name ((object destination))
  :pantalea.networking.intra)

(defmethod protocol:stop! ((connection connection))
  (declare (ignore event))
  connection)

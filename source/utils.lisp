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

(cl:in-package #:pantalea.networking)


(defun find-transport (networking destination)
  (let ((transport-name (or (transport-name destination)
                            (errors:!!! unkown-transport
                                        ("TRANSPORT-NAME for destination ~a could not be found."
                                         destination)))))
    (or (gethash transport-name (transports networking))
        (errors:!!! unkown-transport
                    ("Transport for TRANSPORT-NAME ~a not found in networking."
                     transport-name)))))

(defun make-new-connection (transport destination)
  (declare (optimize (debug 3) (safety 3)))
  (let ((event event-loop:*event*))
    (event-loop:with-existing-events-sequence
        (connect! transport destination)
        event-loop:*event-loop*
        ((connection-established
          (:success ($connection$) :delay 0)
          (log:info "Connection ~a established, will respond to the request."
                    $connection$)
          ;; set status in the transport
          (let ((event-loop:*event* event))
            (event-loop:respond $connection$)))
         (connection-failed
          (:failure ($connection$) :delay 0)
          ;; erase the status in the transport
          (setf (connection transport destination) nil)
          (let ((event-loop:*event* event))
            (event-loop:respond (handler-case $connection$
                                  (error (e) e)))))))))

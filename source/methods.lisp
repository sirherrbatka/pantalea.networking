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

(defmethod initialize-connection :around ((initializer t)
                                          (transport fundamental-transport)
                                          (connection fundamental-connection))
  (errors:with-link (errors:!!! connection-initialization-error)
      (connection-initialization-error)
    (call-next-method)))

(defmethod make-connection :around ((transport fundamental-transport)
                                    destination)
  (errors:with-link (errors:!!! networking-error) (networking-error)
    (call-next-method)))

(defmethod initialize-connection ((initializer t)
                                  (transport fundamental-transport)
                                  (connection fundamental-connection))
  nil)

(defmethod stop! ((networking networking))
  (errors:with-link (errors:!!! unable-to-stop) (unable-to-stop)
    (let ((promises (list)))
      (maphash-values (lambda (transport)
                        (push (stop! transport) promises))
                      (transports networking))
      (promise:combine-every promises))))

(defmethod stop! ((transport fundamental-transport))
  (errors:with-link (errors:!!! unable-to-stop) (unable-to-stop)
    (let ((futures (list)))
      (maphash-values (lambda (connection) (stop! connection)
                        (push (stop! connection) futures))
                      (connections transport))
      (promise:combine-every futures))))

(defmethod stop! :around ((event-loop:*event-loop* fundamental-connection))
  (errors:with-link (errors:!!! unable-to-stop) (unable-to-stop)
    (lret ((result (promise:promise
                     (ignore-errors (call-next-method)))))
      (event-loop:add! event-loop:*event-loop* result))))

(defmethod networking ((connection fundamental-connection))
  (networking (transport connection)))

(defmethod process-incoming-data :around ((networking networking)
                                          processor
                                          data)
  (errors:with-link (errors:!!! data-processing-error) (data-processing-error)
    (call-next-method)))

(defmethod process-outgoing-data :around ((networking networking)
                                          processor
                                          data)
  (errors:with-link (errors:!!! data-processing-error) (data-processing-error)
    (call-next-method)))

(defmethod connect! ((networking networking)
                     destination)
  ;; TODO
  )

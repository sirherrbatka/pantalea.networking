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

(defmethod initialize-connection ((initializer t)
                                  (transport fundamental-transport)
                                  (connection fundamental-connection))
  nil)

(defmethod stop! ((networking networking)
                  &optional event)
  (maphash-values (lambda (transport) (stop! transport))
                  (transports networking))
  (unless (null event) (promise:fullfill! event))
  networking)

(defmethod stop! ((transport fundamental-transport)
                  &optional event)
  (let ((futures (list)))
    (maphash-values (lambda (connection) (stop! connection)
                      (let ((promise (promise:promise nil)))
                        (push promise futures)
                        (stop! connection promise)))
                    (connections transport))
    (promise:force-all futures))
  (unless (null event) (promise:fullfill! event))
  transport)

(defmethod stop! :around ((event-loop:*event-loop* fundamental-connection)
                          &optional event)
  (event-loop:on-event-loop ()
    (ignore-errors (call-next-method))
    (unless (null event) (promise:fullfill! event)))
  (promise:force event-loop:*event-loop*)
  (event-loop:stop! event-loop:*event-loop*)
  event-loop:*event-loop*)

(defmethod networking ((connection fundamental-connection))
  (networking (transport connection)))

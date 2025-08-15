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


(defgeneric connect! (networking destination))
(defgeneric disconnect! (networking connection))
(defgeneric stop! (networking/transport/connection))
(defgeneric destination (connection))
(defgeneric send* (networking connection data))
(defgeneric notify-incoming-data (listener networking connection data))
(defgeneric attach-on-incoming-data! (networking listener))
(defgeneric process-outgoing-data (networking processor data))
(defgeneric process-incoming-data (networking processor data))
(defgeneric add-outgoing-data-processor! (connection processor))
(defgeneric add-incoming-data-processor! (connection processor))
(defgeneric outgoing-data-processors (connection))
(defgeneric incoming-data-processors (connection))
(defgeneric make-connection (transport destination))
(defgeneric initialize-connection (initializer transport connection))
(defgeneric transport-name (object))
(defgeneric networking (object))
(defgeneric connection-initializers (transport))

(defgeneric connection-status (connection))
(defgeneric (setf connection-status) (new-value connection))
(defgeneric connection (networking destination))
(defgeneric (setf connection) (new-value transport destination))
(defgeneric connection-creating-event (connection))
(defgeneric connection-creating-event (connection))

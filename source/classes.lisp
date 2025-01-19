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


(defclass fundamental-transport ()
  ((%connections
    :initarg :connections
    :accessor connections)
   (%outgoing-data-processors-factory
    :initarg :outgoing-data-processors-factory
    :accessor outgoing-data-processors-factory)
   (%incoming-data-processors-factory
    :initarg :incoming-data-processors-factory
    :accessor incoming-data-processors-factory)
   (%connection-initializer
    :initarg :connection-initializer
    :accessor connection-initializer)
   (%incoming-data-listeners
    :initarg :incoming-data-listeners
    :accessor incoming-data-listeners))
  (:default-initargs
   :incoming-data-listeners (vect)
   ))

(defclass fundamental-connection (pantalea.event-loop:event-loop)
  ((%incoming-data-listeners
    :initarg :incoming-data-listeners
    :accessor incoming-data-listeners)
   (%outgoing-data-processors
    :initarg :outgoing-data-processors
    :accessor outgoing-data-processors)
   (%incoming-data-processors
    :initarg :incoming-data-processors
    :accessor incoming-data-processors))
  (:default-initargs
   :incoming-data-listeners (vect)
   :outgoing-data-processors (vect)
   :incoming-data-processors (vect)
   ))

(defclass fundamental-destination ()
  ())

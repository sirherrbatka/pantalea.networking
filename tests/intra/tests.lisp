(cl:in-package #:pantalea.networking.intra)


(rove:deftest establishing-connection
  (let ((event-loop:*event-loop* (make-instance 'pantalea.event-loop:event-loop)))
    (event-loop:start! event-loop:*event-loop*)
    (unwind-protect
         (let* ((*connections* (serapeum:dict))
                (networking-a (protocol:make-networking (make-instance 'transport :key :a)))
                (networking-b (protocol:make-networking (make-instance 'transport :key :b)))
                (connections *connections*)
                (established-connection nil)
                (sequence
                  (event-loop:with-new-events-sequence
                      event-loop:*event-loop*
                      ((connection (:timeout 5)
                                   (let ((*connections* connections))
                                     (protocol:connect! networking-a (make-instance 'destination :key :a))
                                     #'event-loop:data)))
                    (event-loop:add-cell-event! connection))))
           (setf established-connection (event-loop:cell-event-result (event-loop:event-in-events-sequence sequence 'connection)))
           (rove:ok (not (eq established-connection nil)))
           (rove:ok (typep established-connection 'connection))
           (event-loop:stop! established-connection))
      (event-loop:stop! event-loop:*event-loop*))))

#+(or)
(rove:run-test 'establishing-connection)

(rove:deftest simple-connection-test
  (let* ((event-loop:*event-loop* (make-instance 'pantalea.event-loop:event-loop))
         (*connections* (serapeum:dict))
         (networking-a (protocol:make-networking (make-instance 'transport :key :a)))
         (networking-b (protocol:make-networking (make-instance 'transport :key :b)))
         (transport-a (protocol:find-transport networking-a :pantalea.networking.intra))
         (transport-b (protocol:find-transport networking-b :pantalea.networking.intra)))
    (declare (optimize (debug 3)))
    (event-loop:start! event-loop:*event-loop*)
    (unwind-protect
         (let ((connection (protocol:make-connection transport-a (make-instance 'destination :key :b))))
           (rove:ok (not (null connection)))
           (connection-initialization connection transport-b (make-instance 'destination :key :a)))
      (event-loop:stop! event-loop:*event-loop*))))

#+(or)
(rove:run-test 'simple-connection-test)

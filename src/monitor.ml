type monitor = {
  queue : int Queue.t;
  capacity : int;
  mutex : Mutex.t;
  not_empty : Condition.t;
  not_full : Condition.t;
}

let create_monitor capacity =
  if capacity <= 0 then invalid_arg "Capacity must be greater than 0";
  {
    queue = Queue.create ();
    capacity;
    mutex = Mutex.create ();
    not_empty = Condition.create ();
    not_full = Condition.create ();
  }

let log message = Printf.printf "%s\n%!" message

let put buf value =
  Mutex.lock buf.mutex;
  log (Printf.sprintf "[Producer] Trying to put %d" value);
  while Queue.length buf.queue >= buf.capacity do
    log (Printf.sprintf "[Producer] Waiting to put %d (buffer full)" value);
    Condition.wait buf.not_full buf.mutex
  done;
  Queue.add value buf.queue;
  log
    (Printf.sprintf "[Producer] Put %d (buffer size: %d)" value
       (Queue.length buf.queue));
  Condition.signal buf.not_empty;
  log "[Producer] Signaled not_empty";
  Mutex.unlock buf.mutex;
  log "[Producer] Released lock"

let get buf =
  Mutex.lock buf.mutex;
  log "[Consumer] Trying to get";
  while Queue.is_empty buf.queue do
    log "[Consumer] Waiting to get (buffer empty)";
    Condition.wait buf.not_empty buf.mutex
  done;
  let value = Queue.take buf.queue in
  log
    (Printf.sprintf "[Consumer] Got %d (buffer size: %d)" value
       (Queue.length buf.queue));
  Condition.signal buf.not_full;
  log "[Consumer] Signaled not_full";
  Mutex.unlock buf.mutex;
  log "[Consumer] Released lock";
  value

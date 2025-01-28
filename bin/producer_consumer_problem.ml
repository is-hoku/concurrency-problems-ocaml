open Concurrency_problems_ocaml.Monitor

let rec producer buf =
  let value = Random.int 100 in
  put buf value;
  Thread.delay (Random.float 0.5);
  producer buf

let rec consumer buf =
  let _ = get buf in
  Thread.delay (Random.float 0.5);
  consumer buf

let () =
  Random.self_init ();
  let monitor = create_monitor 2 in
  let producer_thread = Thread.create (fun () -> producer monitor) () in
  let consumer_thread = Thread.create (fun () -> consumer monitor) () in
  Thread.join producer_thread;
  Thread.join consumer_thread

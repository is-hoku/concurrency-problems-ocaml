type monitor

val create_monitor : int -> monitor
val put : monitor -> int -> unit
val get : monitor -> int

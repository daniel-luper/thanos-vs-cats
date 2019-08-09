extends Timer

const a = 3
const b = 0.1
const c = 0.8
var elapsed = 0 # Time since timer was initialized

func _process(delta):
	# Update speed
	if !is_stopped():
		elapsed += delta
		set_wait_time(clamp(a - b*elapsed, c, a))
	else:
		elapsed = 0


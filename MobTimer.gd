extends Timer

export var max_wait = 0.9
export var slope = 0.2
export var late_game_slope = 0.001
var elapsed = 0 # Time since timer was initialized

func _process(delta):
	# Update timer_length
	if !is_stopped():
		elapsed += delta
		print(wait_time)
		print(elapsed)
		if elapsed < 35: 
			set_wait_time(max_wait / (max_wait * exp(-(elapsed-45)*(elapsed-45)/(2/slope/slope)) + 1) - 0.1)
		else:
			set_wait_time(0.8 + late_game_slope*elapsed)
	else:
		elapsed = 0

extends Node2D

const MARGIN = 50
signal stones_collected
var original_colors = ["Blue", "Green", "Orange", "Pink", "Red", "Yellow"]
var colors = original_colors.duplicate()
var active_color
var screen_size

func _ready():
	screen_size = get_viewport_rect().size

func begin_spawning():
	$InfinityTimer.start()

func _on_InfinityTimer_timeout():
	if colors.size() > 0:
		position.x = rand_range(MARGIN, screen_size.x - MARGIN)
		position.y = rand_range(MARGIN, screen_size.y - MARGIN)
		active_color = colors[randi() % colors.size()]
		get_node(active_color).show()

func remove_active():
	print(active_color)
	if active_color != null:
		$PickupSound.play()
		$PickupSound.set_pitch_scale(rand_range(0.9, 1))
		get_node(active_color).hide()
		colors.erase(active_color)
		if colors.size() == 0:
			emit_signal("stones_collected")
			colors = original_colors.duplicate()
		else:
			$InfinityTimer.start()
		active_color = null

func reset():
	$InfinityTimer.stop()
	position = Vector2(-100, -100)
	for color in original_colors:
		get_node(color).hide()
	colors = original_colors.duplicate()
	active_color = null
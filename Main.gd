extends Node2D

export (PackedScene) var MobCat
var RainbowCat = preload("res://RainbowCat.tscn")
var DrumCat = preload("res://DrumCat.tscn")
var LoveCat = preload("res://LoveCat.tscn")

var screen_size

var score
var elapsed = 0
var rainbowSpeed = 0
var drumcat_num = 0
var drumcat_pos = Vector2()
var lovecat_numtrios = 0

enum LEVEL {
	one = 500,
	two = 2000,
	three = 3000
}

func _ready():
	screen_size = get_viewport_rect().size
	randomize()
	$Thanos.hide()

func _process(delta):
	elapsed += delta
	
	# Prepare rainbow cat speed
	var max_speed = 420
	var min_speed = 300
	rainbowSpeed = ((max_speed - min_speed) * 2) / (1 + exp(-0.1 * (elapsed - LEVEL.two/100))) - max_speed + 2 * min_speed
	
	# Update love cats
	for i in range(0, 3*lovecat_numtrios):
		var loveCat = get_node("LoveCat" + str(i))
		if loveCat != null:
			if $Thanos.visible == true:
				loveCat.set_destination($Thanos.position)
			else:
				loveCat.set_destination(Vector2())

func game_over():
	$DeathSound.play()
	$ScoreTimer.stop()
	$MobTimer.stop()
	$RainbowTimer.stop()
	$DrumTimer.stop()
	$HUD.show_game_over()
	
func new_game():
	score = 0
	elapsed = 0
	drumcat_num = 0
	lovecat_numtrios = 0
	$InfinityStones.reset()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready\n")
	$Thanos.start($StartPosition.position)
	$Thanos.show()
	$StartTimer.start()

func _on_StartTimer_timeout():
	$ScoreTimer.start()
	$MobTimer.start()

func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)
	# Scripting
	if score == LEVEL.one:
		$HUD.show_message("Collect Infinity Stones!")
		$InfinityStones.begin_spawning()		
	elif score == LEVEL.two:
		$RainbowTimer.start()
	elif score == LEVEL.three:
		_on_DrumTimer_timeout()

func _on_MobTimer_timeout():
	# Choose a random location on Path2D
	$MobPath/MobSpawnLocation.set_offset(randi())
	# Create a mob instance and add it to the scene
	var mobCat = MobCat.instance()
	add_child(mobCat)
	# Set the position, velocity, and direction
	var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
	mobCat.position = $MobPath/MobSpawnLocation.position
	direction += rand_range(-PI / 4, PI / 4)
	mobCat.linear_velocity = Vector2(rand_range(mobCat.min_speed, mobCat.max_speed), 0)
	mobCat.linear_velocity = mobCat.linear_velocity.rotated(direction)
	# Watch for signals
	$HUD.connect("start_game", mobCat, "_on_start_game")
	$HUD.connect("snap", mobCat, "_on_snap")

func _on_RainbowTimer_timeout():
	# Create a new rainbow cat instance
	var rainbowCat = RainbowCat.instance()
	rainbowCat.set_speed(rainbowSpeed)
	add_child(rainbowCat)
	$HUD.connect("snap", rainbowCat, "_on_snap")

func _on_DrumTimer_timeout():
	# Create a new drum cat instance
	var drumCat = DrumCat.instance()
	add_child(drumCat)
	# Set the position, velocity, and direction
	var direction
	var V_LOCATION_MARGIN = 250
	if randi() % 2 == 1:
		direction = 0
		drumCat.position = Vector2(0, rand_range(V_LOCATION_MARGIN, screen_size.y - V_LOCATION_MARGIN))
	else:
		direction = PI
		drumCat.position = Vector2(screen_size.x, rand_range(V_LOCATION_MARGIN, screen_size.y - V_LOCATION_MARGIN))
	direction += rand_range(-PI / 6, PI / 6)
	drumCat.linear_velocity = Vector2(drumCat.speed, 0)
	drumCat.linear_velocity = drumCat.linear_velocity.rotated(direction)
	# Connect signals
	drumCat.connect("exploded", $".", "_on_drumCat_exploded")
	$HUD.connect("start_game", drumCat, "_on_start_game")
	# Decrease time for next timeout then restart timer
	$DrumTimer.set_wait_time(3+0.1*(drumcat_num-10)*(drumcat_num-10))
	$DrumTimer.start()
	drumcat_num += 1

func _on_drumCat_exploded(final_pos):
	$ExplosionSound.play()
	# Create 5 love cat instances
	lovecat_numtrios += 1
	for i in range(0, 3):
		var loveCat = LoveCat.instance()
		loveCat.set_position(Vector2(final_pos.x + i*50-50, final_pos.y + (-0.5 + (i-1)*(i-1)) * 50))
		loveCat.set_name("LoveCat" + str(i + 3 * (lovecat_numtrios-1)))
		add_child(loveCat)
		$HUD.connect("snap", loveCat, "_on_snap")
		$HUD.connect("start_game", loveCat, "_on_start_game")

func _on_Thanos_area_entered(area):
	# Collision with an Infinity Stone
	if area == $InfinityStones:
		$InfinityStones.remove_active()

func _on_InfinityStones_stones_collected():
	$HUD.show_snap()
	$InfinityStones.reset()

func _on_snap():
	$SnapSound.play()
	yield(get_tree().create_timer(2), 'timeout')
	$InfinityStones.begin_spawning()
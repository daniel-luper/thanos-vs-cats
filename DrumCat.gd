extends RigidBody2D

signal exploded

export var speed = 40
export var rate = 0.5
var elapsed = 0
var is_dust = false
var drum_duration = 9.5

func _ready():
	$AnimatedSprite.play()
	$DrumRoll.play()

func _process(delta):
	elapsed += delta
	if elapsed > drum_duration:
		if $AnimatedSprite.playing:
			$AnimatedSprite.stop()
		var scale_val = drum_duration * rate + 1
		_scale(scale_val)
	else:
		var scale_val = elapsed * rate + 1
		_scale(scale_val)

func _scale(val):
	$AnimatedSprite.set_scale(Vector2(val*0.2, val*0.2))
	$CollisionShape2D.set_scale(Vector2(val*0.2, val*0.2))

func _on_Visibility_screen_exited():
	queue_free()

func _on_start_game():
	queue_free()

func _on_snap():
	if randi() % 2 == 1:
		$AnimationPlayer.play("turn_to_dust")
		is_dust = true

func _on_DrumRoll_finished():
	emit_signal("exploded", position)
	queue_free()
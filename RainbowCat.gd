extends RigidBody2D

var speed

var directions = ["right", "left"]
var type = directions[randi() % 2]
var screen_size
var is_dust = false

func set_speed(val):
	speed = val

func _ready():
	screen_size = get_viewport_rect().size
	$AnimatedSprite.animation = type
	$AnimatedSprite.play()
	if type == "right":
		position = Vector2(0, rand_range(0, screen_size.y))
		linear_velocity = Vector2(speed, 0)
	else:
		position = Vector2(screen_size.x, rand_range(0, screen_size.y))
		linear_velocity = Vector2(-speed, 0)

func _on_Visibility_screen_exited():
	queue_free()

func _on_snap():
	if randi() % 2 == 1:
		$AnimationPlayer.play("turn_to_dust")
		is_dust = true

func _on_AnimationPlayer_animation_finished():
	queue_free()

extends RigidBody2D

export var min_speed = 80
export var max_speed = 300

var rotation_speed = rand_range(min_speed, max_speed)
var random_val = rand_range(0, 1)
var is_dust = false

func _ready():
	if random_val > 0.9:
		rotation_speed = 1000
	$Sprite.rotate(rand_range(-PI, PI))

func _process(delta):
	$Sprite.rotate(rotation_speed * delta / 500)

func _on_Visibility_screen_exited():
	queue_free()

func _on_start_game():
	queue_free()

func _on_snap():
	if randi() % 2 == 1:
		$AnimationPlayer.play("turn_to_dust")
		is_dust = true

func _on_AnimationPlayer_animation_finished():
	queue_free()

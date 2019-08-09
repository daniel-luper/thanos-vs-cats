extends RigidBody2D

export var speed = 80
var destination = Vector2(1,1)
var is_dust = false

func _ready():
	$AnimatedSprite.play()

func set_destination(vec):
	destination = vec

func _integrate_forces(state):
	if destination != Vector2():
		var direction = destination - position
		var velocity = direction.normalized() * speed
		set_linear_velocity(velocity)
	else:
		set_linear_velocity(Vector2())

func _on_start_game():
	queue_free()

func _on_snap():
	if randi() % 2 == 1:
		$AnimationPlayer.play("turn_to_dust")
		is_dust = true

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()

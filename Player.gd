extends Area2D

# Declare member variables here. 
signal hit
export var speed = 360
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size

# Called every frame.
func _process(delta):
	var velocity = Vector2() # The player's movement vector
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

func _on_Player_body_entered(body):
	if !body.is_dust:
		hide() # Player disappears after being hit
		#position = Vector2(50, 50)
		emit_signal("hit")
		$CollisionShape2D.set_deferred("disabled", true)
	print(body)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
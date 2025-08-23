extends CharacterBody2D

@onready var sprite = $Sprite
@onready var dash_timer = $DashTimer

@export var movement_speed := 100.0
@export var dash_speed := 250.0

var character_direction:Vector2
var to_dash := false
var dashing := false

func _physics_process(_delta):
	if dashing:
		velocity = character_direction * dash_speed
		move_and_slide()
		return
	character_direction.x = Input.get_axis("move_left","move_right")
	character_direction.y = Input.get_axis("move_up","move_down")
	character_direction = character_direction.normalized()
	
	if character_direction.x > 0:
		sprite.flip_h = false
	elif character_direction.x < 0:
		sprite.flip_h = true
	
	if character_direction:
		if to_dash:
			to_dash = false
			dashing = true
			velocity = character_direction * dash_speed
			sprite.animation = "dash"
		else:
			velocity = character_direction * movement_speed
			sprite.animation = "move"
	else:
		velocity = velocity.move_toward(Vector2.ZERO,movement_speed)
		sprite.animation = "idle"
	
	move_and_slide()

func _input(event):
	if event.is_action_pressed("dash") and !dashing:
		to_dash = true
		dash_timer.start()

func _on_dash_timer_timeout():
	dashing = false

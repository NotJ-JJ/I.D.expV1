extends CharacterBody2D


@export var HealthValue := 100.0:
	set(newHealth):
		hurt(newHealth)
var Health := 0.0
@export var Dead := false

@onready var sprite = $Sprite
@onready var dash_timer = $DashTimer
@onready var dash_cooldown = $DashCooldown

@export var movement_speed := 100.0
@export var dash_speed := 250.0

var character_direction:Vector2
var to_dash := false
var dashing := false
var can_dash := true

func hurt(newHealth):
	Health -= HealthValue-newHealth
	print(Health)
	if Health <= 0:
		sprite.play("death")
		Dead = true
	else:
		sprite.play("hurt")

func _ready():
	Health = HealthValue

func _physics_process(_delta):
	if Dead == true:
		return
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
			sprite.play("dash")
		else:
			velocity = character_direction * movement_speed
			sprite.play("move")
	else:
		velocity = velocity.move_toward(Vector2.ZERO,movement_speed)
		sprite.play("idle")
	
	move_and_slide()

func _input(event):
	if event.is_action_pressed("dash") and !dashing and can_dash:
		can_dash = false
		to_dash = true
		dash_timer.start()

func _on_dash_timer_timeout():
	dashing = false
	dash_cooldown.start()

func _on_dash_cooldown_timeout():
	can_dash = true

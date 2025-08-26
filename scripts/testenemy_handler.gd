extends CharacterBody2D
@onready var sprite = $AnimatedSprite2D

@export var Health := 25.0
@export var Speed := 100.0

var target:CharacterBody2D

func _physics_process(_delta):
	if target:
		if target.Dead == true:
			target = null
			return
		velocity = position.direction_to(target.position)*Speed
		move_and_slide()
		sprite.play("move")
		if (target.position.x - position.x) < 0:
			sprite.flip_h = true
		else:
			sprite.flip_h = false
	else:
		sprite.play("idle")

func _on_detection_zone_body_entered(body):
	if body.Dead == false:
		target = body

func _on_detection_zone_body_exited(body):
	target = null

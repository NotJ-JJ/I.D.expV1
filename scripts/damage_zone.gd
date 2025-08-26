extends Area2D
@onready var timer = $Timer

@export var Damage := 0.0
@export var Cooldown := 1.0

var on_cooldown := false
var target

func Attack():
	if on_cooldown == true or !target:
		return
	if target.Dead == true:
		return
	on_cooldown = true
	target.HealthValue -= Damage
	print("Hit for " + str(Damage))
	timer.start()

func _ready():
	timer.wait_time = Cooldown

func _on_body_entered(body):
	target = body
	Attack()

func _on_body_exited(body):
	target = false

func _on_timer_timeout():
	on_cooldown = false
	Attack()

extends Area2D

@onready var timer = $Timer
@onready var die = $Die

func _on_body_entered(body):
	print("YOU DIED!")
	var animated_sprite = body.get_node("AnimatedSprite2D") 
	animated_sprite.play("die")
	body.is_dead = true
	Engine.time_scale = 0.5
	timer.start()
	die.play()

func _on_timer_timeout():
	Engine.time_scale = 1.0	
	get_tree().reload_current_scene()

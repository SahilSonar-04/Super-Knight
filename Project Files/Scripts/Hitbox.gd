extends Area2D
@onready var animated_sprite_2d = $"../AnimatedSprite2D"
@onready var slime = $".."
@onready var collision_shape_2d = $"../KillZone/CollisionShape2D"

func take_damage():
	print("damage taken")
	slime.speed = 20
	call_deferred("disable_collision_shape")
	animated_sprite_2d.animation = "die"
		
func disable_collision_shape():
	collision_shape_2d.disabled = true	

func _on_animated_sprite_2d_animation_finished():
	if animated_sprite_2d.animation == "die":
		slime.queue_free()
		
	

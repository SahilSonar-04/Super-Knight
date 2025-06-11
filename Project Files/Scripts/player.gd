extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -250.0

@onready var animated_sprite = $AnimatedSprite2D
@onready var jump = $Sounds/Jump
@onready var attack = $Sounds/attack
@onready var collision_shape_2d = $Area2D/CollisionShape2D
@onready var timer = $Timer
@onready var player = $"."

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var is_attacking = false
var is_dead = false
	
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump and jump sound
	if Input.is_action_just_pressed("jump") and is_on_floor() and not is_dead:
		velocity.y = JUMP_VELOCITY
		jump.play()
		
	#Get the input direction -1,0,-,1
	var direction = Input.get_axis("move_left", "move_right")
	
	#Flip sprite
	if direction>0 and not is_dead:
		animated_sprite.flip_h = false
		collision_shape_2d.position = Vector2(12,-6)

	elif direction < 0 and not is_dead:
		animated_sprite.flip_h = true
		collision_shape_2d.position = Vector2(-12,-6)
	
	#applies movement
	if not is_dead:
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	else:
		velocity.x=0
	move_and_slide()
	
	 #Play Animation
	if is_on_floor() and not Input.is_action_just_pressed("attack") and not is_attacking and not is_dead:
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	elif not is_attacking and not is_dead:
		animated_sprite.play("jump")

func _on_animated_sprite_2d_animation_finished():
	if animated_sprite.animation == "attack":
		is_attacking = false
		print("Attack animation finished")
		
	if animated_sprite.animation == "die":
		if $CollisionShape2D:
			$CollisionShape2D.queue_free()
		timer.start()
		

func _on_timer_timeout():
	Engine.time_scale = 1.0	
	get_tree().reload_current_scene()

#attack animation and kill 	
func _process(delta):
	if Input.is_action_just_pressed("attack") and not is_attacking and not is_dead:
		attack.play()
		collision_shape_2d.disabled = false
		animated_sprite.play("attack")
		is_attacking = true
		print("collision box open")
	elif not is_attacking:
		collision_shape_2d.disabled = true

func _on_area_2d_area_entered(area):
	if area.is_in_group("hit"):
		area.take_damage()

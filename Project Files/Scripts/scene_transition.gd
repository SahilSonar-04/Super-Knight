extends CanvasLayer

@onready var animation_player = $AnimationPlayer

func play_transition():
	animation_player.play("entry")

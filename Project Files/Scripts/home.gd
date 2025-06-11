extends Area2D

@export_category("Settings")
@export_file("*.tscn") var target_level_path: String


func _on_body_entered(_body):
	if target_level_path != "":
		get_tree().paused = true
		Transitions.play_transition()
		get_tree().paused = false
		get_tree().change_scene_to_file(target_level_path)
	else:
		print("Target level path is not set.")
	

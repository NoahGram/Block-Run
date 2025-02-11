extends Area3D


func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body is CharacterBody3D:
		Global.current_level += 1
		var next_level_path = "res://Scene/Level/Level_" + str(Global.current_level) + ".tscn"
		if ResourceLoader.exists(next_level_path):  # Ensure level exists before loading
			#get_tree().change_scene_to_file(next_level_path)
			get_tree().change_scene_to_file("res://Scene/level_selector.tscn")
		else:
			print("Level does not exist: ", next_level_path)  # Debugging message
			get_tree().change_scene_to_file("res://Scene/level_selector.tscn")

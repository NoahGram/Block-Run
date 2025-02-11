extends Control


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scene/Level/Level_1.tscn")
	
	
func _on_exit_pressed() -> void:
	get_tree().quit()
	
	
func _on_level_selector_pressed() -> void:
	get_tree().change_scene_to_file("res://Scene/level_selector.tscn")

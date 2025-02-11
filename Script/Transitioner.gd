extends Control
class_name Transitioner

@onready var animation_tex : TextureRect = $TextureRect
@onready var animation_player : AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree
func _ready() -> void:
	animation_tex.visible = false
	animation_player.connect("animation_finished", Callable(self, "_on_animation_finished"))

func start_transition():
	animation_tex.visible = true
	animation_player.play("fade_out")  # Play fade-out animation

func _on_animation_finished(anim_name: String):
	if anim_name == "fade_out":
		get_tree().reload_current_scene()  # Reload only after fade-out finishes

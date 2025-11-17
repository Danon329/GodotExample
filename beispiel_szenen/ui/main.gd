extends Control

const BEISPIEL_LEVEL = preload("uid://d16mv3d2kmn6q")


func _on_button_pressed() -> void:
	var level_scene: PackedScene = BEISPIEL_LEVEL
	get_tree().change_scene_to_packed(level_scene)

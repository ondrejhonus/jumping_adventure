extends Control

func _ready() -> void:
	$VBoxContainer/START.grab_focus()

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/LevelOne.xml.tscn")

func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/options.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()

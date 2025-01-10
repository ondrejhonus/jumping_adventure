extends Area2D

var showInteractionLabel = false

func _ready() -> void:
	$Label.visible = false

func _process(delta: float) -> void:
	$Label.visible = showInteractionLabel
	
	# Kontrola interakce
	if showInteractionLabel and Input.is_action_just_pressed("interact"):
		_change_scene()

func _on_body_entered(body):
	if body is Player:
		showInteractionLabel = true

func _on_body_exited(body):
	if body is Player:
		showInteractionLabel = false

func _change_scene():
	get_tree().change_scene_to_file("res://Scenes/levels.tscn")

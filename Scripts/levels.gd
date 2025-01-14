extends Control

@onready var grid_container: GridContainer = $Menu/Control/HBoxContainer/GridContainer
@onready var back_button: TextureButton = $Menu/Back  # Opraveno na TextureButton
@onready var next_button: TextureButton = $Menu/Next  # Opraveno na TextureButton
@onready var level_difficulty_label: Label = $Menu/levelDificulty  # Label for the difficulty

var num_grids = 1
var current_grid = 1
var grid_width = 548

var level_texts = ["Level Easy", "Level Medium", "Level Hard", "Level Impossible"]
var current_level_index = 0  # Initial level: Level Easy

# Maximum grid count (assuming GridContainer2, GridContainer3, GridContainer4 exist)
var max_grids = 4  # Update based on number of GridContainers

func _ready():
	# Check if grid_container exists
	if grid_container == null:
		print("Error: GridContainer not found!")
		return  # Stop execution if the node does not exist

	num_grids = grid_container.get_child_count()

	# Ensure that we have GridContainers available for navigation
	if num_grids < max_grids:
		print("Warning: Less than 4 GridContainers found!")

	# Adjust the width dynamically based on the number of grids
	if grid_container.has_method("custom_minimum_size"):
		grid_width = grid_container.custom_minimum_size.x
	else:
		print("Error: GridContainer does not have 'custom_minimum_size' property.")
		grid_width = 548  # Default value
	
	set_level_box()

	# Check if buttons exist
	if back_button == null:
		print("Error: BackButton not defined.")
	if next_button == null:
		print("Error: NextButton not defined.")
	
	# Update the initial level difficulty text
	level_difficulty_label.text = level_texts[current_level_index]

func _input(event):
	# Check for key press events to move between GridContainers
	if event is InputEventKey:
		if event.pressed:
			# Move to the next GridContainer
			if event.scancode == KEY_RIGHT:
				_on_next_pressed()
			# Move to the previous GridContainer
			elif event.scancode == KEY_LEFT:
				_on_back_pressed()

	# Handle button presses as well
	if back_button != null and next_button != null:
		if event is InputEventScreenTouch or event is InputEventMouseButton:
			# Check if buttons were pressed
			if back_button.get_rect().has_point(event.position) and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				_on_back_pressed()
			elif next_button.get_rect().has_point(event.position) and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				_on_next_pressed()

func set_level_box():
	# Check if children of grid_container exist
	for grid in grid_container.get_children():
		if not grid.has_method("get_children"):
			print("Error: Grid node does not have 'get_children' method.")
			continue
		for box in grid.get_children():
			if box.has_method("set"):
				# Make sure 'level_num' and 'locked' are accessible
				if "level_num" in box and "locked" in box:
					box.level_num = box.get_index() + 1 + grid.get_child_count() * grid.get_index()
					box.locked = false
				else:
					print("Error: Box node does not contain 'level_num' or 'locked' properties.")
			else:
				print("Error: Box node does not contain 'set' method.")

func _on_back_pressed() -> void:
	if current_grid > 1:
		current_grid -= 1
		animateGridPosition(grid_container.position.x + grid_width)

	# Update the difficulty label when moving back
	update_level_label()

func _on_next_pressed() -> void:
	if current_grid < max_grids:
		current_grid += 1
		animateGridPosition(grid_container.position.x - grid_width)

	# Update the difficulty label when moving forward
	update_level_label()

func animateGridPosition(finalValue):
	if grid_container == null:
		print("Error: GridContainer does not exist.")
		return
	var tween = create_tween()
	if tween:
		tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tween.tween_property(grid_container, "position:x", finalValue, 0.5)
	else:
		print("Error: Cannot create Tween.")

# Update the level difficulty label
func update_level_label() -> void:
	# Ensure the current grid number is used to update the level label
	if current_grid == 1:
		current_level_index = 0  # Easy
	elif current_grid == 2:
		current_level_index = 1  # Medium
	elif current_grid == 3:
		current_level_index = 2  # Hard
	elif current_grid == 4:
		current_level_index = 3  # Impossible

	# Update the label with the appropriate level
	level_difficulty_label.text = level_texts[current_level_index]

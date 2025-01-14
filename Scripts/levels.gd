extends Control

@onready var grid_container: GridContainer = $Menu/Control/HBoxContainer/GridContainer
@onready var back_button: TextureButton = $Menu/Back
@onready var next_button: TextureButton = $Menu/Next
@onready var level_difficulty_label: Label = $Menu/levelDificulty

var num_grids = 1
var current_grid = 1
var grid_width = 548

var level_texts = ["Level Easy", "Level Medium", "Level Hard", "Level Impossible"]
var current_level_index = 0  # Initial level: Level Easy

# Maximum grid count
var max_grids = 4  # Update based on number of GridContainers

func _ready():
	# Ensure the grid_container is valid
	if grid_container == null:
		print("Error: GridContainer not found!")
		return
	
	num_grids = grid_container.get_child_count()

	# Ensure we have at least the expected number of GridContainers
	if num_grids < max_grids:
		print("Warning: Less than 4 GridContainers found!")

	# Dynamically adjust width based on the number of grids
	if grid_container.has_method("custom_minimum_size"):
		grid_width = grid_container.custom_minimum_size.x
	else:
		print("Error: GridContainer does not have 'custom_minimum_size' property.")
		grid_width = 548  # Default value

	set_level_box()

	# Check if the buttons exist
	if back_button == null:
		print("Error: BackButton not defined.")
	if next_button == null:
		print("Error: NextButton not defined.")
	
	# Update the difficulty label
	level_difficulty_label.text = level_texts[current_level_index]

func _input(event):
	# Handle key presses
	if event is InputEventKey:
		if event.pressed:
			if event.scancode == KEY_RIGHT:
				_on_next_pressed()
			elif event.scancode == KEY_LEFT:
				_on_back_pressed()

	# Handle button presses (mouse or touch)
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		if back_button.get_rect().has_point(event.position) and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			_on_back_pressed()
		elif next_button.get_rect().has_point(event.position) and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			_on_next_pressed()

func set_level_box():
	# Ensure each grid and its children are correctly set
	for grid in grid_container.get_children():
		if grid.has_method("get_children"):
			for box in grid.get_children():
				if box.has_method("set"):
					# Assuming 'level_num' and 'locked' properties exist in box nodes
					if "level_num" in box and "locked" in box:
						box.level_num = box.get_index() + 1 + grid.get_child_count() * grid.get_index()
						box.locked = false
					else:
						print("Error: Box node does not contain 'level_num' or 'locked' properties.")
				else:
					print("Error: Box node does not contain 'set' method.")
		else:
			print("Error: Grid node does not have 'get_children' method.")

func _on_back_pressed() -> void:
	if current_grid > 1:
		current_grid -= 1
		animateGridPosition(grid_container.position.x + grid_width)
	# Update the difficulty label
	update_level_label()

func _on_next_pressed() -> void:
	if current_grid < max_grids:
		current_grid += 1
		animateGridPosition(grid_container.position.x - grid_width)
	# Update the difficulty label
	update_level_label()

func animateGridPosition(final_value: float):
	# Ensure the grid_container exists
	if grid_container == null:
		print("Error: GridContainer does not exist.")
		return
	
	# Create a tween and animate the position change
	var tween = create_tween()
	if tween:
		tween.tween_property(grid_container, "position:x", final_value, 0.5)
	else:
		print("Error: Cannot create Tween.")

func update_level_label() -> void:
	# Update the level difficulty label based on the current grid
	if current_grid == 1:
		current_level_index = 0  # Easy
	elif current_grid == 2:
		current_level_index = 1  # Medium
	elif current_grid == 3:
		current_level_index = 2  # Hard
	elif current_grid == 4:
		current_level_index = 3  # Impossible

	# Update the label text
	level_difficulty_label.text = level_texts[current_level_index]

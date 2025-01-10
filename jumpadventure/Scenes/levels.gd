extends Control

@onready var grid_container = $LevelMenu/ClipControl/GridContainer
@onready var back_button = $LevelMenu/ClipControl/BackButton
@onready var next_button = $LevelMenu/ClipControl/NextButton
@onready var level_difficulty_label = $LevelMenu/ClipControl/LevelDifficulty  # Label pro úroveň obtížnosti

var num_grids = 1
var current_grid = 1
var grid_width = 548

var level_texts = ["Level Easy", "Level Medium", "Level Hard", "Level Impossible"]
var current_level_index = 0  # Počáteční úroveň: Level Easy

func _ready():
	# Ověření, zda `grid_container` existuje
	if grid_container == null:
		print("Chyba: GridContainer není správně definován.")
		return
	
	num_grids = grid_container.get_child_count()
	if grid_container.has_method("custom_minimum_size"):
		grid_width = grid_container.custom_minimum_size.x
	else:
		print("Chyba: GridContainer nemá vlastnost 'custom_minimum_size'.")
		grid_width = 548  # Výchozí hodnota
	
	set_level_box()

	# Zajistíme, že tlačítka jsou inicializována, než na ně zavoláme metody
	if back_button == null:
		print("Chyba: BackButton není definován.")
	if next_button == null:
		print("Chyba: NextButton není definován.")

func _input(event):
	# Ověříme, zda tlačítka existují, než budeme volat get_rect() nebo jinou metodu
	if back_button != null and next_button != null:
		if event is InputEventScreenTouch or event is InputEventMouseButton:
			# Zkontrolujeme, zda byla tlačítka stisknuta
			if back_button.get_rect().has_point(event.position) and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				_on_back_pressed()
			elif next_button.get_rect().has_point(event.position) and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				_on_next_pressed()

func set_level_box():
	# Ověření, zda děti existují a mají očekávané metody
	for grid in grid_container.get_children():
		if not grid.has_method("get_children"):
			print("Chyba: Uzel grid nemá metodu 'get_children'.")
			continue
		for box in grid.get_children():
			if box.has_method("set"):
				box.level_num = box.get_index() + 1 + grid.get_child_count() * grid.get_index()
				box.locked = false
			else:
				print("Chyba: Box neobsahuje vlastnost 'level_num' nebo 'locked'.")

func _on_back_pressed() -> void:
	# Při stisknutí zpět snížíme index a aktualizujeme text
	if current_level_index > 0:
		current_level_index -= 1
		level_difficulty_label.text = level_texts[current_level_index]
		print("Změněno na: " + level_texts[current_level_index])
	
	if current_grid > 1:
		current_grid -= 1
		animateGridPosition(grid_container.position.x + grid_width)

func _on_next_pressed() -> void:
	# Při stisknutí pokračování zvýšíme index a aktualizujeme text
	if current_level_index < level_texts.size() - 1:
		current_level_index += 1
		level_difficulty_label.text = level_texts[current_level_index]
		print("Změněno na: " + level_texts[current_level_index])
	
	if current_grid < num_grids:
		current_grid += 1
		animateGridPosition(grid_container.position.x - grid_width)

func animateGridPosition(finalValue):
	if not grid_container:
		print("Chyba: GridContainer neexistuje.")
		return
	var tween = create_tween()
	if tween:
		tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tween.tween_property(grid_container, "position:x", finalValue, 0.5)
	else:
		print("Chyba: Nelze vytvořit Tween.")

extends CharacterBody2D  # Použití správného typu uzlu pro Godot 4.x

const TARGET_FPS = 60
const ACCELERATION = 8.0
const MAX_SPEED = 64.0
const FRICTION = 10.0
const AIR_RESISTANCE = 1.0
const GRAVITY = 4.0
const JUMP_FORCE = 140.0
const MAX_FALL_SPEED = 500.0  # Maximální rychlost pádu
const INTERACTION_DISTANCE = 40.0  # Vzdálenost pro interakci

var motion = Vector2.ZERO  # Inicializace pohybu
var in_interaction_range = false  # Pokud je hráč v dosahu pro interakci
var item = null  # Odkaz na objekt itemu pro interakci

@onready var sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer

# Zjištění, zda je hráč v dosahu itemu
func _on_area_entered(area: Area2D):
	if area.is_in_group("items"):  # Pokud je item ve skupině "items"
		in_interaction_range = true
		item = area  # Uložení odkazu na item

# Když hráč opustí oblast itemu
func _on_area_exited(area: Area2D):
	if area.is_in_group("items"):  # Pokud je item ve skupině "items"
		in_interaction_range = false
		item = null

func _physics_process(delta):
	var x_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	# Horizontální pohyb
	if x_input != 0:
		motion.x += x_input * ACCELERATION * delta * TARGET_FPS
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
		sprite.flip_h = x_input < 0  # Otočení sprite, pokud je pohyb vlevo
		if is_on_floor():
			if not animation_player.is_playing() or animation_player.current_animation != "Run":
				animation_player.play("Run")  # Spuštění animace "Run"
	else:
		if is_on_floor():
			motion.x = lerp(motion.x, 0.0, FRICTION * delta)
			if not animation_player.is_playing() or animation_player.current_animation != "Stand":
				animation_player.play("Stand")  # Spuštění animace "Stand"
		else:
			motion.x = lerp(motion.x, 0.0, AIR_RESISTANCE * delta)
	
	# Vertikální pohyb
	motion.y += GRAVITY * delta * TARGET_FPS

	# Omezíme maximální rychlost pádu
	if motion.y > MAX_FALL_SPEED:
		motion.y = MAX_FALL_SPEED

	if is_on_floor():
		if Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_select"):  # Skákání pomocí "ui_up" nebo "Space"
			motion.y = -JUMP_FORCE
			if not animation_player.is_playing() or animation_player.current_animation != "Jump":
				animation_player.play("Jump")  # Spuštění animace "Jump"
	else:
		if Input.is_action_just_released("ui_up") and motion.y < -JUMP_FORCE / 2:
			motion.y = -JUMP_FORCE / 2
		if not is_on_floor():
			if not animation_player.is_playing() or animation_player.current_animation != "Jump":
				animation_player.play("Jump")  # Spuštění animace "Jump"
	
	# Interakce s itemem
	if in_interaction_range and Input.is_action_just_pressed("ui_accept"):  # "ui_accept" je klávesa pro "E"
		interact_with_item()

	# Pohyb
	velocity = motion  # Aktualizace velocity pro CharacterBody2D
	move_and_slide()

# Funkce pro interakci s itemem
func interact_with_item():
	if item != null:
		animation_player.play("Interact")  # Spuštění animace pro interakci
		print("Interacting with item:", item.name)  # Příklad, co se stane při interakci
		# Tady můžete přidat kód pro to, co se stane, když hráč interaguje s předmětem (např. přidání předmětu do inventáře)

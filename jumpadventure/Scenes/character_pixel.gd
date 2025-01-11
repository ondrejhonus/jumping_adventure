extends CharacterBody2D  # Použití správného typu uzlu pro Godot 4.x

const TARGET_FPS = 60
const ACCELERATION = 8.0
const MAX_SPEED = 64.0
const FRICTION = 10.0
const AIR_RESISTANCE = 1.0
const GRAVITY = 4.0
const JUMP_FORCE = 140.0
const MAX_FALL_SPEED = 500.0  # Maximální rychlost pádu

var motion = Vector2.ZERO  # Inicializace pohybu

@onready var sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer

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
	
	# Pohyb
	velocity = motion  # Aktualizace velocity pro CharacterBody2D
	move_and_slide()

extends CharacterBody2D

@export var speed: float = 200.0
@export var radius: float = 10.0

func _physics_process(delta):
	var direction = Vector2.ZERO
	
	# Desktop controls
	if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP):
		direction.y -= 1
	if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN):
		direction.y += 1
	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
		direction.x -= 1
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
		direction.x += 1
	
	# Mobile controls (simplified - in real implementation, use touch input)
	# For now, use mouse position for mobile-like control
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var mouse_pos = get_viewport().get_mouse_position()
		direction = (mouse_pos - position).normalized()
	
	if direction != Vector2.ZERO:
		velocity = direction * speed
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed)
	
	# Keep player within screen bounds
	position.x = clamp(position.x, radius, 800 - radius)
	position.y = clamp(position.y, radius, 600 - radius)
	
	move_and_slide()
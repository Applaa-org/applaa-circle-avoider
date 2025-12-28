extends CharacterBody2D

@export var speed: float = 100.0
@export var radius: float = 20.0

var direction: Vector2

func _ready():
	direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()

func _physics_process(delta):
	velocity = direction * speed
	move_and_slide()
	
	# Bounce off edges
	if position.x <= radius or position.x >= 800 - radius:
		direction.x *= -1
	if position.y <= radius or position.y >= 600 - radius:
		direction.y *= -1
	
	# Keep within bounds
	position.x = clamp(position.x, radius, 800 - radius)
	position.y = clamp(position.y, radius, 600 - radius)
extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var score_label: Label = $HUD/ScoreLabel
@onready var high_score_label: Label = $HUD/HighScoreLabel
@onready var timer: Timer = $ScoreTimer
@onready var spawn_timer: Timer = $SpawnTimer
@onready var difficulty_timer: Timer = $DifficultyTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var particle_system: GPUParticles2D = $ParticleSystem

var score: int = 0
var high_score: int = 0
var enemy_scene = preload("res://scenes/Enemy.tscn")
var enemies: Array = []

func _ready():
	# Initialize HUD
	if score_label:
		score_label.text = "Score: 0"
	if high_score_label:
		high_score_label.text = "Best: 0"
		high_score_label.visible = true
	
	# Load game data
	load_game_data()
	
	# Start timers
	timer.start()
	spawn_timer.start()
	difficulty_timer.start()
	
	# Spawn initial enemies
	for i in range(3):
		spawn_enemy()
	
	# Play entrance animation
	if animation_player:
		animation_player.play("game_start")

func _process(delta):
	# Check for victory condition (survive 60 seconds)
	if score >= 60:
		victory()
	
	# Update particle effects
	if particle_system and score > 0:
		particle_system.emitting = true

func load_game_data():
	JavaScriptBridge.eval("""
	window.parent.postMessage({ type: 'applaa-game-load-data', gameId: 'circle-avoider' }, '*');
	""")

func _on_score_timer_timeout():
	score += 1
	score_label.text = "Score: " + str(score)
	
	# Update high score if beaten
	if score > high_score:
		high_score = score
		high_score_label.text = "Best: " + str(high_score)
		
		# Play high score animation
		if animation_player:
			animation_player.play("high_score")

func spawn_enemy():
	var enemy = enemy_scene.instantiate()
	enemy.position = Vector2(randf_range(50, 750), randf_range(50, 550))
	add_child(enemy)
	enemies.append(enemy)
	
	# Play spawn animation
	if enemy.has_node("AnimationPlayer"):
		enemy.get_node("AnimationPlayer").play("spawn")

func _on_spawn_timer_timeout():
	spawn_enemy()

func _on_difficulty_timer_timeout():
	# Increase difficulty every 10 seconds
	for enemy in enemies:
		if enemy:
			enemy.speed += 20
	
	# Play difficulty increase effect
	if animation_player:
		animation_player.play("difficulty_up")

func check_collision():
	for enemy in enemies:
		if enemy and player.position.distance_to(enemy.position) < (player.radius + enemy.radius):
			game_over()

func victory():
	# Save score
	save_score_to_storage(Global.player_name, score)
	
	# Play victory animation
	if animation_player:
		animation_player.play("victory")
		await animation_player.animation_finished
	
	get_tree().change_scene_to_file("res://scenes/VictoryScreen.tscn")

func game_over():
	# Save score
	save_score_to_storage(Global.player_name, score)
	
	# Play game over animation
	if animation_player:
		animation_player.play("game_over")
		await animation_player.animation_finished
	
	get_tree().change_scene_to_file("res://scenes/DefeatScreen.tscn")

func save_score_to_storage(player_name: String, final_score: int):
	JavaScriptBridge.eval("""
	window.parent.postMessage({
		type: 'applaa-game-save-score',
		gameId: 'circle-avoider',
		playerName: '""" + player_name + """',
		score: """ + str(final_score) + """
	}, '*');
	""")

func _on_data_loaded(game_data: Dictionary):
	high_score = game_data.get("highScore", 0)
	if high_score_label:
		high_score_label.text = "Best: " + str(high_score)
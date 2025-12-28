extends Control

@onready var score_label: Label = $VBoxContainer/ScoreLabel
@onready var restart_button: Button = $VBoxContainer/RestartButton
@onready var main_menu_button: Button = $VBoxContainer/MainMenuButton
@onready var close_button: Button = $VBoxContainer/CloseButton
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	score_label.text = "Final Score: " + str(Global.score)
	restart_button.pressed.connect(_on_restart_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)
	close_button.pressed.connect(_on_close_pressed)
	
	# Play defeat animation
	if animation_player:
		animation_player.play("defeat_entrance")

func _on_restart_pressed():
	# Play exit animation
	if animation_player:
		animation_player.play("exit")
		await animation_player.animation_finished
	
	Global.reset_score()
	get_tree().reload_current_scene()

func _on_main_menu_pressed():
	# Play exit animation
	if animation_player:
		animation_player.play("exit")
		await animation_player.animation_finished
	
	Global.reset_score()
	get_tree().change_scene_to_file("res://scenes/StartScreen.tscn")

func _on_close_pressed():
	# Play exit animation
	if animation_player:
		animation_player.play("exit")
		await animation_player.animation_finished
	
	get_tree().quit()
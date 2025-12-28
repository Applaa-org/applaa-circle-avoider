extends Control

@onready var start_button: Button = $VBoxContainer/StartButton
@onready var close_button: Button = $VBoxContainer/CloseButton
@onready var high_score_label: Label = $VBoxContainer/HighScoreLabel
@onready var player_name_input: LineEdit = $VBoxContainer/PlayerNameInput
@onready var loading_label: Label = $VBoxContainer/LoadingLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var is_loading: bool = false

func _ready():
	start_button.pressed.connect(_on_start_pressed)
	close_button.pressed.connect(_on_close_pressed)
	player_name_input.text_changed.connect(_on_name_changed)
	
	# Initialize high score display to 0
	if high_score_label:
		high_score_label.text = "High Score: 0"
		high_score_label.visible = true
	
	# Hide loading initially
	if loading_label:
		loading_label.visible = false
	
	# Load game data
	load_game_data()
	
	# Play entrance animation
	if animation_player:
		animation_player.play("fade_in")

func load_game_data():
	if loading_label:
		loading_label.visible = true
		loading_label.text = "Loading game data..."
	
	# Request data from Applaa storage
	JavaScriptBridge.eval("""
	window.parent.postMessage({ type: 'applaa-game-load-data', gameId: 'circle-avoider' }, '*');
	""")

func _on_start_pressed():
	if is_loading:
		return
	
	var player_name = player_name_input.text.strip_edges()
	if player_name == "":
		player_name = "Player"
	
	# Play exit animation
	if animation_player:
		animation_player.play("fade_out")
		await animation_player.animation_finished
	
	Global.player_name = player_name
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_close_pressed():
	# Play exit animation
	if animation_player:
		animation_player.play("fade_out")
		await animation_player.animation_finished
	
	get_tree().quit()

func _on_name_changed(new_text: String):
	# Real-time validation
	if new_text.length() > 20:
		player_name_input.text = new_text.substr(0, 20)
		player_name_input.caret_column = 20

# Handle data loaded from localStorage
func _on_data_loaded(game_data: Dictionary):
	if loading_label:
		loading_label.visible = false
	
	var high_score = game_data.get("highScore", 0)
	var last_player = game_data.get("lastPlayerName", "")
	
	# Update high score display
	if high_score_label:
		high_score_label.text = "High Score: " + str(high_score)
	
	# Pre-fill player name
	if player_name_input and last_player != "":
		player_name_input.text = last_player
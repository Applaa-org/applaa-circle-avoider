extends Control

@onready var start_button: Button = $VBoxContainer/StartButton
@onready var close_button: Button = $VBoxContainer/CloseButton
@onready var high_score_label: Label = $VBoxContainer/HighScoreLabel
@onready var player_name_input: LineEdit = $VBoxContainer/PlayerNameInput

func _ready():
	start_button.pressed.connect(_on_start_pressed)
	close_button.pressed.connect(_on_close_pressed)
	
	# Initialize high score display to 0
	if high_score_label:
		high_score_label.text = "High Score: 0"
		high_score_label.visible = true
	
	# Load game data from localStorage
	load_game_data()

func load_game_data():
	# Request data from Applaa storage
	JavaScriptBridge.eval("""
	window.parent.postMessage({ type: 'applaa-game-load-data', gameId: 'circle-avoider' }, '*');
	""")

func _on_start_pressed():
	# Save player name if entered
	var player_name = player_name_input.text.strip_edges()
	if player_name != "":
		Global.player_name = player_name
	
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_close_pressed():
	get_tree().quit()

# Handle data loaded from localStorage
func _on_data_loaded(game_data: Dictionary):
	var high_score = game_data.get("highScore", 0)
	var last_player = game_data.get("lastPlayerName", "")
	
	# Update high score display
	if high_score_label:
		high_score_label.text = "High Score: " + str(high_score)
	
	# Pre-fill player name
	if player_name_input and last_player != "":
		player_name_input.text = last_player
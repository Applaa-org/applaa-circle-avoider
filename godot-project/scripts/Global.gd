extends Node

var score: int = 0
var player_name: String = "Player"

func add_score(points: int):
	score += points

func reset_score():
	score = 0
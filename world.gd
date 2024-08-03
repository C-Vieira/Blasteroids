extends Node2D

# Hello World! Again!
# Changing some stuff around...

@export var game_stats: GameStats

@onready var score_label = $ScoreLabel

func _ready():
	randomize()
	update_score_label(game_stats.score)
	game_stats.score_changed.connect(update_score_label)

func update_score_label(new_score: int):
	score_label.text = "Score: " + str(new_score)

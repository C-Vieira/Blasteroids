extends CanvasLayer

@export var game_stats: GameStats

@onready var score_label: Label = %ScoreLabel

func _ready() -> void:
	update_score_label(game_stats.score)
	game_stats.score_changed.connect(update_score_label)

func update_score_label(new_score: int):
	score_label.text = "Score: " + str(new_score)

extends Control

@export var game_stats: GameStats

@onready var variable_pitch_audio_stream_player = $VariablePitchAudioStreamPlayer
@onready var highscore_label = $CenterContainer/VBoxContainer/HighscoreLabel

func _ready():
	highscore_label.text = "Final score: " + str(game_stats.score)
	variable_pitch_audio_stream_player.play_with_variance()

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		game_stats.score = 0
		get_tree().change_scene_to_file("res://ui/title/menu.tscn")

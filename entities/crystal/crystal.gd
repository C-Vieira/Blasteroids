extends Area2D

var direction_vector = Vector2.DOWN

@onready var move_component = $MoveComponent
@onready var visible_on_screen_notifier_2d = $VisibleOnScreenNotifier2D
@onready var variable_pitch_audio_stream_player = $VariablePitchAudioStreamPlayer
@onready var score_component = $ScoreComponent

func _ready():
	rotation = randf_range(0, 2*PI)
	move_component.direction = direction_vector.rotated(rotation)
	visible_on_screen_notifier_2d.screen_exited.connect(queue_free)

func _on_area_entered(area):
	print("Crystal Collected!")
	score_component.adjust_score(5)
	variable_pitch_audio_stream_player.play_with_variance()

func _on_variable_pitch_audio_stream_player_finished():
	queue_free()

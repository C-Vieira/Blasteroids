extends Node2D

func _ready():
	RenderingServer.set_default_clear_color(Color.BLACK)

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().reload_current_scene()

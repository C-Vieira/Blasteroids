extends Control

func _process(delta):
	RenderingServer.set_default_clear_color(Color.BLACK)
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene_to_file("res://world.tscn")

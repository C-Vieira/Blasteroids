extends Camera2D

func _unhandled_input(event):
	if event.is_action_pressed("zoom_in"):
		if self.zoom == Vector2(1.0, 1.0): return
		self.zoom += Vector2(0.1, 0.1)
	elif event.is_action_pressed("zoom_out"):
		if self.zoom == Vector2(0.1, 0.1): return
		self.zoom -= Vector2(0.1, 0.1)

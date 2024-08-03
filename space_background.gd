extends ParallaxBackground

@onready var distant_stars_layer = %DistantStarsLayer
@onready var close_stars_layer = %CloseStarsLayer

func _process(delta):
	distant_stars_layer.motion_offset.y += 5 * delta
	close_stars_layer.motion_offset.y += 20 * delta

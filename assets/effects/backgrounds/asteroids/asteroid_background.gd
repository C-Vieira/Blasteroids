extends ParallaxBackground

@onready var distant_asteroids_layer: ParallaxLayer = %DistantAsteroidsLayer
@onready var close_asteroids_layer: ParallaxLayer = %CloseAsteroidsLayer

func _process(delta):
	distant_asteroids_layer.motion_offset.y += 15 * delta
	close_asteroids_layer.motion_offset.y += 35 * delta

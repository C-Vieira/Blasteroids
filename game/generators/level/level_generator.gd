extends Node

@onready var tile_map_layer: TileMapLayer = $TileMapLayer

var debris_tile = preload("res://entities/tile_entities/debris/debris_tile.tscn")

func _on_noise_generator_generation_finished():
	var map :Rect2i = tile_map_layer.get_used_rect()
	
	for x in range(map.position.x, map.end.x):
		for y in range(map.position.y, map.end.y):
			var cell = tile_map_layer.get_cell_atlas_coords(Vector2i(x, y))
			
			if cell == Vector2i(1, 1): #Spawn Debris tiles on ground
				var new_tile = debris_tile.instantiate()
				new_tile.global_position = tile_map_layer.map_to_local(Vector2i(x, y))
				get_tree().current_scene.add_child(new_tile)
			else:
				pass

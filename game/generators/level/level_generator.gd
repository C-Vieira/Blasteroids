extends Node

@export var room_amount: int = 3

@onready var tile_map_layer: TileMapLayer = $TileMapLayer

var map: Rect2i
var debris_tile: PackedScene = preload("res://entities/tile_entities/debris/debris_tile.tscn")
var regolith_tile: PackedScene = preload("res://entities/tile_entities/regolith/regolith_tile.tscn")
var basalt_tile: PackedScene = preload("res://entities/tile_entities/basalt/basalt_tile.tscn")
var hard_tile: PackedScene = preload("res://entities/tile_entities/hard_tile/hard_tile.tscn")

func _ready() -> void:
	map = tile_map_layer.get_used_rect()

func _on_noise_generator_generation_finished() -> void:
	
	for x: int in range(map.position.x, map.end.x):
		for y: int in range(map.position.y, map.end.y):
			var cell: Vector2i = tile_map_layer.get_cell_atlas_coords(Vector2i(x, y))
			
			if cell == Vector2i(1, 1): #Spawn Debris tiles on ground
				var new_tile: Node2D = debris_tile.instantiate()
				new_tile.global_position = tile_map_layer.map_to_local(Vector2i(x, y))
				get_tree().current_scene.add_child(new_tile)
			if cell == Vector2i(1, 0): #Spawn Regolith tiles on ground
				var new_tile: Node2D = regolith_tile.instantiate()
				new_tile.global_position = tile_map_layer.map_to_local(Vector2i(x, y))
				get_tree().current_scene.add_child(new_tile)
			if cell == Vector2i(2, 0): #Spawn Basalt tiles on ground
				var new_tile: Node2D = basalt_tile.instantiate()
				new_tile.global_position = tile_map_layer.map_to_local(Vector2i(x, y))
				get_tree().current_scene.add_child(new_tile)
			else:
				pass
	
	spawn_rooms()

func spawn_rooms() -> void:
	var room_height: int
	var room_width: int
	var start_pos: Vector2i
	
	for i: int in room_amount:
		room_height = randi_range(5, 9)
		room_width = randi_range(7, 9)
		start_pos = Vector2i(randi_range(map.position.x, map.end.x), randi_range(map.position.y, map.end.y))
		
		for x: int in room_width:
			for y: int in room_height:
				#Place floor
				tile_map_layer.set_cell(Vector2i(start_pos.x + x, start_pos.y + y), 2, Vector2i(2, 0))
				
				#Place walls
				if(x == room_width - 1 or x == 0 or y == room_height - 1 or y == 0):
					#tile_map_layer.set_cell(Vector2i(start_pos.x + x, start_pos.y + y), 2, Vector2i(3, 0))
					
					var new_tile: Node2D = hard_tile.instantiate()
					new_tile.global_position = tile_map_layer.map_to_local(Vector2i(start_pos.x + x, start_pos.y + y))
					get_tree().current_scene.add_child(new_tile)

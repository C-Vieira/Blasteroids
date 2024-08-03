class_name SpawnerComponent
extends Node

@export var scene: PackedScene

func spawn(global_spawn_position: Vector2, parent: Node = get_tree().current_scene) -> Node:
	var instance = scene.instantiate()
	parent.add_child(instance)
	
	instance.global_position = global_spawn_position
	instance.global_rotation = parent.global_rotation
	
	return instance

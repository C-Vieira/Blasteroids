class_name WraparoundComponent
extends Node

@export var Actor : Node2D
@export var collision_shape_2d : CollisionShape2D


func _physics_process(delta):
	var radius = collision_shape_2d.shape.radius
	var screen_size = Actor.get_viewport_rect().size
	if (Actor.global_position.y + radius) < 0:
		Actor.global_position.y = (screen_size.y + radius)
	elif (Actor.global_position.y - radius) > screen_size.y:
		Actor.global_position.y = -radius
	elif (Actor.global_position.x + radius) < 0:
		Actor.global_position.x = (screen_size.x + radius)
	elif (Actor.global_position.x - radius) > screen_size.x:
		Actor.global_position.x = -radius

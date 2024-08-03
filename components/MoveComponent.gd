class_name MoveComponent
extends Node

@export var actor: Node2D
@export var speed: int
@export var direction: Vector2

func _process(delta):
	actor.position += direction * speed * delta

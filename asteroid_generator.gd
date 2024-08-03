extends Node2D

@export var AsteroidScene: PackedScene
@export var parent: Node

var asteroid_scene = preload("res://asteroid.tscn")
var crystal_scene = preload("res://crystal.tscn")

var margin = 9
var screen_width = ProjectSettings.get_setting("display/window/size/viewport_width")

@onready var spawner_component = $SpawnerComponent
@onready var asteroid_timer = $AsteroidTimer

func _ready():
	asteroid_timer.timeout.connect(handle_spawn.bind(AsteroidScene, asteroid_timer))

func handle_spawn(scene: PackedScene, timer: Timer):
	spawner_component.scene = scene
	
	var asteroid = spawner_component.spawn(Vector2(randf_range(margin, screen_width - margin), -16))
	asteroid.exploded.connect(_on_asteroid_exploded)
	
	var spawn_rate = 5
	timer.start(spawn_rate)

func _on_asteroid_exploded(pos, size, had_crystals):
	print("Ateroid Exploded!")
	for i in range(2):
		match size:
			Asteroid.AsteroidSizes.LARGE:
				spawn_smaller_asteroid(pos, Asteroid.AsteroidSizes.MEDIUM, had_crystals)
			Asteroid.AsteroidSizes.MEDIUM:
				spawn_smaller_asteroid(pos, Asteroid.AsteroidSizes.SMALL, had_crystals)
			Asteroid.AsteroidSizes.SMALL:
				if had_crystals:
					spawn_crystal(pos)
				else:
					pass

func spawn_smaller_asteroid(pos, size, had_crystals):
	print("Spawning a new asteroid")
	var new_asteroid = asteroid_scene.instantiate()
	new_asteroid.global_position = pos
	new_asteroid.size = size
	new_asteroid.has_crystals = had_crystals
	new_asteroid.exploded.connect(_on_asteroid_exploded)
	get_tree().current_scene.add_child(new_asteroid)

func spawn_crystal(pos):
	print("Spawning crystal")
	var crystal = crystal_scene.instantiate()
	crystal.global_position = pos
	get_tree().current_scene.add_child(crystal)

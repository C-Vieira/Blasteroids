extends Node2D

@export var EnemyScene: PackedScene

@onready var spawner_component = $SpawnerComponent
@onready var enemy_timer = $EnemyTimer

var margin = 9
var screen_width = ProjectSettings.get_setting("display/window/size/viewport_width")

func _ready():
	enemy_timer.timeout.connect(handle_spawn.bind(EnemyScene, enemy_timer))

func handle_spawn(scene: PackedScene, timer: Timer):
	spawner_component.scene = scene
	
	spawner_component.spawn(Vector2(randf_range(margin, screen_width - margin), -16))
	
	var spawn_rate = 2.5
	timer.start(spawn_rate)

extends Node2D

@export var MineEnemyScene: PackedScene
@export var ProbeEnemyScene: PackedScene

@export var game_stats: GameStats

@onready var spawner_component: SpawnerComponent = $SpawnerComponent
@onready var mine_enemy_spawn_timer: Timer = $MineEnemySpawnTimer
@onready var probe_enemy_spawn_timer: Timer = $ProbeEnemySpawnTimer

var margin = 9
var screen_width = ProjectSettings.get_setting("display/window/size/viewport_width")

func _ready():
	mine_enemy_spawn_timer.timeout.connect(handle_spawn.bind(MineEnemyScene, mine_enemy_spawn_timer))
	probe_enemy_spawn_timer.timeout.connect(handle_spawn.bind(ProbeEnemyScene, probe_enemy_spawn_timer), 3.7)
	
	game_stats.score_changed.connect(func(new_score: int):
		if(new_score > 100):
			probe_enemy_spawn_timer.process_mode = Node.PROCESS_MODE_INHERIT
	)

func handle_spawn(enemy_scene: PackedScene, timer: Timer, time_offset: float = 1.0) -> void:
	spawner_component.scene = enemy_scene
	
	spawner_component.spawn(Vector2(randf_range(margin, screen_width - margin), -16))
	
	var spawn_rate = time_offset / (0.5 + (game_stats.score * 0.01))   
	timer.start(spawn_rate + randf_range(0.25, 0.5))

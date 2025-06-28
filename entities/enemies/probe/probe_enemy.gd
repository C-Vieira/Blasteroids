extends Enemy

@onready var states: Node = $States

@onready var move_down_state_component: TimedStateComponent = %MoveDownStateComponent
@onready var move_side_state_component: TimedStateComponent = %MoveSideStateComponent
@onready var pause_state_component: TimedStateComponent = %PauseStateComponent
@onready var move_side_component: MoveComponent = %MoveSideComponent
@onready var fire_state_component: StateComponent = %FireStateComponent
@onready var projectile_spawner_component: SpawnerComponent = %ProjectileSpawnerComponent

func _ready() -> void:
	super()
	
	for state in states.get_children():
		state = state as StateComponent
		state.disable()
	
	move_side_component.direction = [Vector2(-1, 0), Vector2(1, 0)].pick_random()
	
	move_down_state_component.state_finished.connect(move_side_state_component.enable)
	move_side_state_component.state_finished.connect(func():
		fire_state_component.enable()
		scale_component.tween_scale()
		projectile_spawner_component.spawn(global_position)
		fire_state_component.disable()
		fire_state_component.state_finished.emit()
	)
	fire_state_component.state_finished.connect(pause_state_component.enable)
	pause_state_component.state_finished.connect(move_down_state_component.enable)
	
	move_down_state_component.enable()

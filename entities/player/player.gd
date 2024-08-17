extends CharacterBody2D

var screen_size: Vector2
var acceleration: float = 20
var friction: float = 250
var max_speed: float = 120
var shot_cooldown: bool = false
var no_health: bool = false

@onready var spawner_component: SpawnerComponent = $SpawnerComponent
@onready var cannon_1: Marker2D = $Cannon1
@onready var cannon_2: Marker2D = $Cannon2
@onready var stats_component: StatsComponent = $StatsComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var destroyed_component: DestroyedComponent = $DestroyedComponent
@onready var scale_component: ScaleComponent = $ScaleComponent
@onready var variable_pitch_audio_stream_player: VariablePitchAudioStreamPlayer = $VariablePitchAudioStreamPlayer
@onready var flash_component: FlashComponent = $FlashComponent
@onready var shake_component: ShakeComponent = $ShakeComponent
@onready var hurt_audio_stream_player: VariablePitchAudioStreamPlayer = $HurtAudioStreamPlayer
@onready var collection_area: Area2D = $CollectionArea

func _ready()-> void:
	screen_size = get_viewport_rect().size
	
	stats_component.no_health.connect(func()-> void:
		no_health = true
		destroyed_component.destroy.unbind(1)
		get_tree().change_scene_to_file("res://ui/game_over/game_over.tscn")
	)
	
	hurtbox_component.hurt.connect(func(_hitbox: HitboxComponent)-> void:
		if no_health: return
		scale_component.tween_scale()
		flash_component.flash()
		shake_component.tween_shake()
		hurt_audio_stream_player.play_with_variance()
	)

func fire_lasers()-> void:
	variable_pitch_audio_stream_player.play_with_variance()
	spawner_component.spawn(cannon_1.global_position, self)
	spawner_component.spawn(cannon_2.global_position, self)
	scale_component.tween_scale()

func get_input(delta: float)-> void:
	var input_direction: Vector2 = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down")).normalized()
	
	velocity += input_direction * acceleration
	velocity = velocity.limit_length(max_speed)
	
	if input_direction == Vector2.ZERO:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	position = position.clamp(Vector2.ZERO, screen_size)

func _physics_process(delta: float)-> void:
	get_input(delta)
	move_and_slide()
	
	if Input.is_action_pressed("shoot"):
		if !shot_cooldown:
			shot_cooldown = true
			fire_lasers()
			await get_tree().create_timer(0.25).timeout
			shot_cooldown = false

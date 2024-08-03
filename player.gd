extends CharacterBody2D

var screen_size
var acceleration = 20
var friction = 250
var rotation_speed = 250
var max_speed = 120
var shot_cooldown = false
var no_health = false

@onready var spawner_component = $SpawnerComponent
@onready var cannon_1 = $Cannon1
@onready var cannon_2 = $Cannon2
@onready var stats_component = $StatsComponent
@onready var hurtbox_component = $HurtboxComponent
@onready var destroyed_component = $DestroyedComponent
@onready var scale_component = $ScaleComponent
@onready var variable_pitch_audio_stream_player = $VariablePitchAudioStreamPlayer
@onready var flash_component = $FlashComponent
@onready var shake_component = $ShakeComponent
@onready var hurt_audio_stream_player = $HurtAudioStreamPlayer
@onready var collection_area = $CollectionArea

func _ready():
	screen_size = get_viewport_rect().size
	
	stats_component.no_health.connect(func():
		no_health = true
		destroyed_component.destroy.unbind(1)
		get_tree().change_scene_to_file("res://game_over.tscn")
	)
	
	hurtbox_component.hurt.connect(func(hitbox: HitboxComponent):
		if no_health: return
		scale_component.tween_scale()
		flash_component.flash()
		shake_component.tween_shake()
		hurt_audio_stream_player.play_with_variance()
	)

func fire_lasers():
	variable_pitch_audio_stream_player.play_with_variance()
	spawner_component.spawn(cannon_1.global_position, self)
	spawner_component.spawn(cannon_2.global_position, self)
	scale_component.tween_scale()

func get_input(delta):
	var input_direction = Vector2(0, Input.get_axis("up", "down"))
	
	velocity += input_direction.rotated(rotation) * acceleration
	velocity = velocity.limit_length(max_speed)
	
	if Input.is_action_pressed("right"):
		rotate(deg_to_rad(rotation_speed * delta))
	if Input.is_action_pressed("left"):
		rotate(deg_to_rad(-rotation_speed * delta))
	
	if input_direction.y == 0:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	position = position.clamp(Vector2.ZERO, screen_size)

func _physics_process(delta):
	get_input(delta)
	move_and_slide()
	
	if Input.is_action_pressed("shoot"):
		if !shot_cooldown:
			shot_cooldown = true
			fire_lasers()
			await get_tree().create_timer(0.25).timeout
			shot_cooldown = false

class_name Asteroid
extends Node2D

signal exploded(pos, size, had_crystals)

@export var has_crystals = randi_range(0, 1)

@onready var stats_component = $StatsComponent
@onready var sprite = $Sprite
@onready var crystal_sprite = $CrystalSprite
@onready var destroyed_component = $DestroyedComponent
@onready var hurtbox_component = $HurtboxComponent
@onready var collision_shape_2d = $HurtboxComponent/CollisionShape2D
@onready var move_component = $MoveComponent
@onready var flash_component = $FlashComponent
@onready var scale_component = $ScaleComponent
@onready var shake_component = $ShakeComponent
@onready var variable_pitch_audio_stream_player = $VariablePitchAudioStreamPlayer

@export var size = randi_range(0, 2)
enum AsteroidSizes {LARGE, MEDIUM, SMALL}

var direction_vector = Vector2.DOWN

func _ready():
	rotation = randf_range(0, 2*PI)
	move_component.direction = direction_vector.rotated(rotation)
	
	match size:
		AsteroidSizes.LARGE:
			move_component.speed = randf_range(20, 30)
			sprite.frame = 2
			collision_shape_2d.shape = preload("res://resources/asteroid_large.tres")
			
		AsteroidSizes.MEDIUM:
			move_component.speed = randf_range(30, 40)
			sprite.frame = 1
			collision_shape_2d.shape = preload("res://resources/asteroid_medium.tres")
			
		AsteroidSizes.SMALL:
			move_component.speed = randf_range(40, 50)
			sprite.frame = 0
			collision_shape_2d.shape = preload("res://resources/asteroid_small.tres")
			
	
	if has_crystals:
		crystal_sprite.visible = true
		crystal_sprite.frame = sprite.frame
	
	hurtbox_component.hurt.connect(func(hitbox: HitboxComponent):
		scale_component.tween_scale()
		flash_component.flash()
		shake_component.tween_shake()
		variable_pitch_audio_stream_player.play_with_variance()
	)
	
	stats_component.no_health.connect(explode)

func _physics_process(delta):
	var radius = collision_shape_2d.shape.radius
	var screen_size = get_viewport_rect().size
	if (global_position.y + radius) < 0:
		global_position.y = (screen_size.y + radius)
	elif (global_position.y - radius) > screen_size.y:
		global_position.y = -radius
	elif (global_position.x + radius) < 0:
		global_position.x = (screen_size.x + radius)
	elif (global_position.x - radius) > screen_size.x:
		global_position.x = -radius

func explode():
	print("Exploded signal emitted")
	exploded.emit(global_position, size, has_crystals)
	queue_free()

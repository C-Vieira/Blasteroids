extends CharacterBody2D

var acceleration: int = 10
var friction: int = 300
var rotation_speed: int = 300
var max_speed: int = 200
var drill_cooldown: bool = false

@export var fire_power: float = 0.25

@onready var drill_hit_box : CollisionShape2D = $HitboxComponent/CollisionShape2D
@onready var drill_shake_component : ShakeComponent = $DrillShakeComponent
@onready var scale_component: ScaleComponent = $ScaleComponent
@onready var spawner_component: SpawnerComponent = $SpawnerComponent
@onready var cannon: Marker2D = $Cannon

func _ready() -> void:
	rotation = 0.0

func get_input(delta: float) -> void:
	#Movement Scheme 1
	var input_direction: Vector2 = Vector2(0, Input.get_axis("up", "down"))
	
	velocity += input_direction.rotated(rotation) * acceleration
	velocity = velocity.limit_length(max_speed)
	
	if Input.is_action_pressed("right"):
		rotate(deg_to_rad(rotation_speed * delta))
	if Input.is_action_pressed("left"):
		rotate(deg_to_rad(-rotation_speed * delta))
	
	if input_direction.y == 0:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	#Movement Scheme 2
	#var input_direction: Vector2 = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down")).normalized()
	#
	#velocity += input_direction * acceleration
	#velocity = velocity.limit_length(max_speed)
	#
	#if Input.is_action_pressed("right"):
		#rotation = deg_to_rad(90.0)
	#if Input.is_action_pressed("left"):
		#rotation = deg_to_rad(270.0)
	#if Input.is_action_pressed("up"):
		#rotation = deg_to_rad(0.0)
	#if Input.is_action_pressed("down"):
		#rotation = deg_to_rad(180.0)
	#
	#if input_direction == Vector2.ZERO:
		#velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	global_position = global_position.clamp(Vector2.ZERO, Vector2(2056, 2056))

func fire_lasers()-> void:
	spawner_component.spawn(cannon.global_position, self)
	scale_component.tween_scale()

func _physics_process(delta: float) -> void:
	get_input(delta)
	move_and_slide()
	
	if Input.is_action_pressed("shoot"):
		#drill_shake_component.tween_shake()
		if !drill_cooldown:
			drill_cooldown = true
			#drill_hit_box.disabled = false
			fire_lasers()
			await get_tree().create_timer(fire_power).timeout
			#drill_hit_box.disabled = true
			drill_cooldown = false

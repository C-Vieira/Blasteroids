extends CharacterBody2D

var acceleration: int = 10
var friction: int = 300
var rotation_speed: int = 300
var max_speed: int = 200
var drill_cooldown: bool = false

@onready var drill_hit_box : CollisionShape2D = $HitboxComponent/CollisionShape2D
@onready var drill_shake_component : ShakeComponent = $DrillShakeComponent

func _ready() -> void:
	rotation = 0.0

func get_input(delta: float) -> void:
	var input_direction: Vector2 = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down")).normalized()
	
	velocity += input_direction * acceleration
	velocity = velocity.limit_length(max_speed)
	
	if Input.is_action_pressed("right"):
		rotation = deg_to_rad(90.0)
	if Input.is_action_pressed("left"):
		rotation = deg_to_rad(270.0)
	if Input.is_action_pressed("up"):
		rotation = deg_to_rad(0.0)
	if Input.is_action_pressed("down"):
		rotation = deg_to_rad(180.0)
	
	if input_direction == Vector2.ZERO:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	global_position = global_position.clamp(Vector2.ZERO, Vector2(2056, 2056))

func _physics_process(delta: float) -> void:
	get_input(delta)
	move_and_slide()
	
	if Input.is_action_pressed("shoot"):
		drill_shake_component.tween_shake()
		if !drill_cooldown:
			drill_cooldown = true
			drill_hit_box.disabled = false
			await get_tree().create_timer(0.25).timeout
			drill_hit_box.disabled = true
			drill_cooldown = false

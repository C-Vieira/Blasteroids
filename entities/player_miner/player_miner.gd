extends CharacterBody2D

var acceleration = 10
var friction = 300
var rotation_speed = 300
var max_speed = 200
var drill_cooldown = false

@onready var drill_hit_box : CollisionShape2D = $HitboxComponent/CollisionShape2D
@onready var drill_shake_component : ShakeComponent = $DrillShakeComponent

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
	
	global_position = global_position.clamp(Vector2.ZERO, Vector2(2056, 2056))

func _physics_process(delta):
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

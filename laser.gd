extends Node2D

@onready var visible_on_screen_notifier_2d = $VisibleOnScreenNotifier2D
@onready var move_component = $MoveComponent
@onready var hitbox_component = $HitboxComponent
@onready var scale_component = $ScaleComponent
@onready var flash_component = $FlashComponent

var move_direction = Vector2(0, -1)

func _ready():
	scale_component.tween_scale()
	flash_component.flash()
	visible_on_screen_notifier_2d.screen_exited.connect(queue_free)
	hitbox_component.hit_hurtbox.connect(queue_free.unbind(1))

func _physics_process(delta):
	move_component.direction = move_direction.rotated(rotation)

class_name HurtComponent
extends Node

@export var stats_component: StatsComponent
@export var hurt_box_component: HurtboxComponent

func _ready():
	hurt_box_component.hurt.connect(func(hitbox_component: HitboxComponent):
		stats_component.health -= hitbox_component.damage
	)

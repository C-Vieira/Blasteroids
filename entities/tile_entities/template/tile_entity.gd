class_name TileEntity
extends Node2D

@onready var hurtbox_component : HurtboxComponent = $HurtboxComponent
@onready var shake_component : ShakeComponent = $ShakeComponent
@onready var scale_component : ScaleComponent = $ScaleComponent
@onready var flash_component : FlashComponent = $FlashComponent
@onready var stats_component : StatsComponent = $StatsComponent
@onready var hurt_audio_stream_player : VariablePitchAudioStreamPlayer = $HurtAudioStreamPlayer

func _ready():
	hurtbox_component.hurt.connect(func(hitbox : HitboxComponent):
		hurt_audio_stream_player.play_with_variance()
		shake_component.tween_shake()
		flash_component.flash()
		scale_component.tween_scale()
	)
	stats_component.no_health.connect(tile_destroyed)

func tile_destroyed():
	pass

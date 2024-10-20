class_name RegolithTileEntity
extends TileEntity

signal destroyed(pos: Vector2, had_crytals: bool)

var has_crystals: bool

@onready var crystal_sprite: Sprite2D = $CrystalSprite

func _ready() -> void:
	hurtbox_component.hurt.connect(func(_hitbox : HitboxComponent) -> void:
		hurt_audio_stream_player.play_with_variance()
		shake_component.tween_shake()
		flash_component.flash()
		scale_component.tween_scale()
	)
	stats_component.no_health.connect(tile_destroyed)
	
	has_crystals = randi_range(0, 1)
	
	if has_crystals:
		crystal_sprite.visible = true

func tile_destroyed() -> void:
	destroyed.emit(global_position, has_crystals)

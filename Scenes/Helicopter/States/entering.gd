extends State

@export var helicopter_volume_db: float = 5.0

@onready var helicopter: Node2D = state_machine.entity_root
@onready var flight_sfx: AudioStreamPlayer = state_machine.flight_sfx

var sfx_tween: Tween

## Position just off screen when first instantiated
func _ready() -> void:
	super()
	helicopter.global_position.x = get_viewport().get_visible_rect().size.x + (%CollisionShape2D.shape.size.x / 2) + 32.0
	helicopter.global_position.y = (%CollisionShape2D.shape.size.y / 2) + 32.0

## Ramp up sfx volume to announce entry before moving onto screen and seeking the player
func enter() -> void:
	sfx_tween = self.create_tween()
	sfx_tween.tween_property(flight_sfx, "volume_db", helicopter_volume_db, 3.5)
	sfx_tween.set_ease(Tween.EASE_OUT)
	sfx_tween.set_trans(Tween.TRANS_QUINT)
	await sfx_tween.finished
	transition_to("seeking")


func exit() -> void:
	sfx_tween.stop()

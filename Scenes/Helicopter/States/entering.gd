extends State

@export var helicopter_volume_db: float = 5.0

@onready var helicopter: Node2D = state_machine.entity_root
@onready var flight_sfx: AudioStreamPlayer = state_machine.flight_sfx

var sfxTween: Tween

func _ready() -> void:
	super()
	helicopter.global_position.x = get_viewport().get_visible_rect().size.x + (%CollisionShape2D.shape.size.x / 2) + 32.0
	helicopter.global_position.y = (%CollisionShape2D.shape.size.y / 2) + 32.0


func enter() -> void:
	sfxTween = self.create_tween()
	sfxTween.tween_property(flight_sfx, "volume_db", helicopter_volume_db, 3.5)
	sfxTween.set_ease(Tween.EASE_OUT)
	sfxTween.set_trans(Tween.TRANS_QUINT)
	await sfxTween.finished
	transition_to("seeking")


func exit() -> void:
	sfxTween.stop()

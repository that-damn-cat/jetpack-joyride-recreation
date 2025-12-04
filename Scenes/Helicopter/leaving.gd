extends State

@export var leave_speed: float = 100.0

@onready var helicopter: Node2D = state_machine.entity_root

var speed_tween: Tween
var current_speed: float = 0.0


func _ready() -> void:
	leave_speed += Globals.run_speed
	super()


func enter() -> void:
	# Tween to accelerate up to leave_speed, using sine easing (Speeds up over 1 second)
	speed_tween = self.create_tween()
	speed_tween.tween_property(self, "current_speed", leave_speed, 1.0)
	speed_tween.set_ease(Tween.EASE_IN_OUT)
	speed_tween.set_trans(Tween.TRANS_SINE)


func physics_update(delta: float) -> void:
	helicopter.global_position.x -= current_speed * delta
extends State

@export var seek_speed: float = 200.0

@onready var helicopter: Node2D = state_machine.entity_root

var speed_tween: Tween
var current_speed: float = 0.0

func _ready() -> void:
	super()
	seek_speed += Globals.run_speed


func enter() -> void:
	# Turn on the shape cast to find the player
	%ShapeCast2D.enabled = true

	# Tween to accelerate up to seek_speed, using sine easing (Speeds up over 2 seconds)
	speed_tween = self.create_tween()
	speed_tween.tween_property(self, "current_speed", seek_speed, 2.0)
	speed_tween.set_ease(Tween.EASE_IN_OUT)
	speed_tween.set_trans(Tween.TRANS_SINE)


func update(_delta: float) -> void:
	# If we see the player...
	if %ShapeCast2D.is_colliding():
		# Turn off the shapecast since we don't need it anymore.
		%ShapeCast2D.enabled = false

		# Remove the old tween (if it's still going)
		speed_tween.kill()

		# Make a new one to replace it, to decelerate back to 0, using sine easing again. (Slows down over 0.6 seconds)
		speed_tween = self.create_tween()
		speed_tween.tween_property(self, "current_speed", 0.0, 0.6)
		speed_tween.set_ease(Tween.EASE_IN_OUT)
		speed_tween.set_trans(Tween.TRANS_SINE)

		# Wait until the tween is finished before transitioning states
		await speed_tween.finished
		transition_to("firing")


func physics_update(delta: float) -> void:
	helicopter.global_position.x -= current_speed * delta
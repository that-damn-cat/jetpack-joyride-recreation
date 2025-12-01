extends State

@onready var controlled_node : CharacterBody2D = state_machine.controlled_node
@export var death_bounce_velocity: float = 750.0
@export var min_x_impulse_mult: float = 0.25
@export var max_x_impulse_mult: float = 1.75

var death_x_impulse: float

func enter() -> void:
	controlled_node.velocity.y -= death_bounce_velocity
	death_x_impulse = Globals.run_speed * randf_range(min_x_impulse_mult, max_x_impulse_mult)
	death_x_impulse *= [-1.0, 1.0].pick_random()

	if death_x_impulse < 0:
		%Sprite2D.flip_h = false
	else:
		%Sprite2D.flip_h = true

	%AnimationPlayer.play("die")

func update(_delta: float) -> void:
	if %Sprite2D.visible == false:
		queue_free()

func physics_update(_delta: float) -> void:
	if not controlled_node.is_on_floor():
		controlled_node.velocity.x = death_x_impulse - Globals.run_speed
	else:
		controlled_node.velocity.x = -Globals.run_speed

	controlled_node.velocity.y += 90.0
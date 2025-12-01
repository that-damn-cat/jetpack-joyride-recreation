extends State

@onready var controlled_node : CharacterBody2D = state_machine.controlled_node
@export var max_flee_speed : float = 200.0
@export var min_flee_speed : float = 125.0

var flee_speed : float = 0.0

func enter() -> void:
	flee_speed = randf_range(min_flee_speed, max_flee_speed)
	flee_speed *= [-1, 1].pick_random()

	%AnimationPlayer.play("run")

	if flee_speed < 0:
		%Sprite2D.flip_h = true
	else:
		%Sprite2D.flip_h = false

func physics_update(_delta: float) -> void:
	controlled_node.velocity.x = -Globals.run_speed + flee_speed

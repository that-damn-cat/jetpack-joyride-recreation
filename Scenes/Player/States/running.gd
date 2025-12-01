@tool
extends State

@export var target_x_pos: float = 100.0
@export var ground_drag_rate: float = 9.0
var player : CharacterBody2D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player") as CharacterBody2D

func enter() -> void:
	%AnimationPlayer.play("run_right")

func update(_delta: float) -> void:
	if Input.is_action_pressed("jump"):
		transitioned.emit(self, "lifting")

func physics_update(_delta: float) -> void:
	player.velocity.y = 0

	if player.global_position.x < target_x_pos:
		player.global_position.x = target_x_pos
	elif player.global_position.x > target_x_pos:
		player.velocity.x -= (ground_drag_rate * Globals.run_speed) / Globals.base_run_speed

	if player.velocity.x < -Globals.run_speed:
		player.velocity.x = -Globals.run_speed
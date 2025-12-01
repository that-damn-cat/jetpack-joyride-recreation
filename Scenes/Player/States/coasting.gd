@tool
extends State

@export_category("Coasting Forces")
@export var jetpack_coast_gravity : float = 50.0
@export_range(0.0, 1.0, 0.05) var coast_break : float = 0.8

var player : CharacterBody2D
var fall_state : State

func enter() -> void:
	%AnimationPlayer.play("coast_right")

func _ready() -> void:
	if Engine.is_editor_hint():
		return

	player = get_tree().get_first_node_in_group("Player") as CharacterBody2D
	fall_state = state_machine.get_state("falling")

func physics_update(_delta: float) -> void:
	player.velocity.y += jetpack_coast_gravity

	if player.velocity.y >= fall_state.terminal_velocity * coast_break:
		transitioned.emit(self, "falling")
		return

	if player.velocity.x > 0:
		player.velocity.x = lerp(player.velocity.x, 0.0, 0.05)

	if player.is_on_floor():
		transitioned.emit(self, "running")
		return

func update(_delta: float) -> void:
	if Input.is_action_pressed("jump"):
		transitioned.emit(self, "lifting")

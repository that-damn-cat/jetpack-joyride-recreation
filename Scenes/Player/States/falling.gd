@tool
extends State

@export_category("Gravity")
@export var gravity : float = 190.0
@export var terminal_velocity : float = 850.0

var player : CharacterBody2D

func enter() -> void:
	%AnimationPlayer.play("fall_right")

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player") as CharacterBody2D

func physics_update(_delta: float) -> void:
	player.velocity.y += gravity
	if player.velocity.y > terminal_velocity:
		player.velocity.y = terminal_velocity

	if player.velocity.x > 0:
		player.velocity.x = lerp(player.velocity.x, 0.0, 0.05)

	if player.is_on_floor():
		transitioned.emit(self, "running")

func update(_delta: float) -> void:
	if Input.is_action_pressed("jump"):
		transitioned.emit(self, "lifting")

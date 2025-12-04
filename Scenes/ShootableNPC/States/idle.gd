extends State

@onready var controlled_node: CharacterBody2D = state_machine.controlled_node

@export var idle_min_time: float = 0.35
@export var idle_max_time: float = 0.75

var idle_time: float = 0.0
var idle_elapsed_time: float = 0.0

func enter() -> void:
	%AnimationPlayer.play('idle')

	idle_time = randf_range(idle_min_time, idle_max_time)
	idle_elapsed_time = 0.0


func update(delta: float) -> void:
	idle_elapsed_time += delta

	if idle_elapsed_time >= idle_time:
		transitioned.emit(self, "wandering")


func physics_update(_delta: float) -> void:
	controlled_node.velocity.x = -Globals.run_speed


func try_flee():
	if state_machine.current_state == self:
		transitioned.emit(self, "fleeing")


func _on_hazard_detector_body_entered(_body: Node2D) -> void:
	try_flee()


func _on_hazard_detector_area_entered(_area: Area2D) -> void:
	try_flee()

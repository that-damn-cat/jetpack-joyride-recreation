extends State

@onready var controlled_node: CharacterBody2D = state_machine.controlled_node

@export var wander_speed: float = 50.0
@export var wander_min_time: float = 0.35
@export var wander_max_time: float = 0.75

var wander_time: float = 0.0
var wander_elapsed_time: float = 0.0

func enter() -> void:
	%HazardDetector.set_deferred("monitoring", true)
	%AnimationPlayer.play('walk')

	wander_speed *= [-1.0, 1.0].pick_random()

	if wander_speed < 0.0:
		%Sprite2D.flip_h = true
	else:
		%Sprite2D.flip_h = false

	wander_time = randf_range(wander_min_time, wander_max_time)
	wander_elapsed_time = 0.0


func update(delta: float) -> void:
	wander_elapsed_time += delta

	if wander_elapsed_time >= wander_time:
		transitioned.emit(self, "idle")


func physics_update(_delta: float) -> void:
	controlled_node.velocity.x = -Globals.run_speed + wander_speed


func exit() -> void:
	if %HazardDetector:
		%HazardDetector.set_deferred("monitoring", false)


func try_flee():
	if state_machine.current_state == self:
		transitioned.emit(self, "fleeing")


func _on_hazard_detector_body_entered(_body: Node2D) -> void:
	try_flee()


func _on_hazard_detector_area_entered(_area: Area2D) -> void:
	try_flee()

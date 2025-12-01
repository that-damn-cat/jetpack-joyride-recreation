extends State

@export var wander_speed: float = 50.0
@export var wander_min_time: float = 0.35
@export var wander_max_time: float = 0.75

@onready var controlled_node: CharacterBody2D = state_machine.controlled_node

var wandering: bool = false
var wander_time_elapsed: float = 0.0
var wander_time: float = 0.0

func enter() -> void:
	%HazardDetector.set_deferred("monitoring", true)
	wandering = [true, false].pick_random()
	wander_setup()


func update(delta: float) -> void:
	wander_time_elapsed += delta

	if wander_time_elapsed >= wander_time:
		wander_setup()

	if wandering:
		%AnimationPlayer.play('walk')
	else:
		%AnimationPlayer.play('idle')


func physics_update(_delta: float) -> void:
	controlled_node.velocity.x = -Globals.run_speed

	if wandering:
		controlled_node.velocity.x = -Globals.run_speed + wander_speed


func exit() -> void:
	%HazardDetector.set_deferred("monitoring", false)


func try_flee():
	if state_machine.current_state == self:
		transitioned.emit(self, "fleeing")


func wander_setup():
	wandering = not wandering

	wander_speed *= [1.0, -1.0].pick_random()

	if wandering:
		if wander_speed < 0:
			%Sprite2D.flip_h = true
		elif wander_speed > 0:
			%Sprite2D.flip_h = false

	wander_time = randf_range(wander_min_time, wander_max_time)
	wander_time_elapsed = 0.0

	if not wandering:
		wander_time *= 3.0


func _on_hazard_detector_body_entered(_body: Node2D) -> void:
	try_flee()


func _on_hazard_detector_area_entered(_area: Area2D) -> void:
	try_flee()
extends StateMachine

@export var controlled_node : CharacterBody2D

func _ready() -> void:
	initial_state = [get_state('idle'), get_state('wandering')].pick_random()
	super()


func _on_health_component_died() -> void:
	%Hurtbox2D.queue_free()
	change_state("dying")
@icon("./choice.svg")
class_name State
extends Node

signal transitioned(this_state: State, new_state_name: String)
var state_machine : StateMachine

@export var state_name: String = name.to_lower()

func _ready() -> void:
	if get_parent() is not StateMachine:
		push_error("State nodes must be children of a StateMachine node.")


func enter() -> void:
	pass


func exit() -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	pass


func transition_to(new_state_name: String) -> void:
	transitioned.emit(self, new_state_name)

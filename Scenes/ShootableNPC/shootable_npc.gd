class_name ShootableNPC
extends CharacterBody2D

@export var sprite_options: Array[Texture2D]

func _ready() -> void:
	%Sprite2D.texture = sprite_options.pick_random()

func _physics_process(_delta: float) -> void:
	move_and_slide()
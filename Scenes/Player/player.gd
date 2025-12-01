extends CharacterBody2D

func _physics_process(_delta: float) -> void:
	move_and_slide()

func _process(_delta):
	%AnimationPlayer.speed_scale = Globals.run_speed / Globals.base_run_speed

func _on_health_component_died() -> void:
	print("Died!")
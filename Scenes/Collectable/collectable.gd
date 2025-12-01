@icon("./swap-bag.svg")
class_name Collectable
extends Area2D

@export var points: int = 1

signal collected

func collect():
	collected.emit()
	%Animation.visible = false
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)
	%CollectSFX.play_jitter()

func _process(delta: float) -> void:
	global_position.x -= Globals.run_speed * delta

	if (not %Animation.is_playing()) and %FreeNotifier2D.is_on_screen():
		%Animation.play("default")

func _on_area_entered(area: Area2D) -> void:
	if area in get_tree().get_nodes_in_group("Player"):
		collect()

func _on_body_entered(body: Node2D) -> void:
	if body in get_tree().get_nodes_in_group("Player"):
		collect()

func _on_collect_sfx_finished() -> void:
	queue_free()
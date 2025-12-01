extends Node

@export_category("Game Settings")
@export var speed_increase_per_second: float = 2.5

@export_category("Shootable NPCs")
@export var shootable_npc: PackedScene
@export var shootable_spawnpoint: Vector2 = Vector2(1500.0, 576.0)
@export var min_group_size: int = 1
@export var max_group_size: int = 8
@export var min_group_spacing: float = 28.0
@export var max_group_spacing: float = 50.0
@export var min_spawn_seconds: float = 5.0
@export var max_spawn_seconds: float = 15.0

var spawn_time_elapsed: float = 0.0
var next_spawn_time: float = 0.0

@export_category("Coin Patterns")
@export var coin_patterns: Array[PackedScene]
@export var pattern_min_delay: float = 4.0
@export var pattern_max_delay: float = 8.0

var pattern_time_elapsed: float = 0.0
var next_pattern_time: float = 0.0

var music_time: float = 0.0

func _ready() -> void:
	next_spawn_time = randf_range(min_spawn_seconds, max_spawn_seconds)
	next_pattern_time = randf_range(pattern_min_delay, pattern_max_delay)

func _process(delta: float) -> void:
	spawn_time_elapsed += delta
	pattern_time_elapsed += delta
	music_time += delta

	Globals.run_speed += speed_increase_per_second * delta

	if spawn_time_elapsed >= next_spawn_time:
		var spawn_count = randi_range(min_group_size, max_group_size)
		spawn_group(shootable_npc, shootable_spawnpoint, spawn_count, min_group_spacing, max_group_spacing)
		spawn_time_elapsed = 0.0
		next_spawn_time = randf_range(min_spawn_seconds, max_spawn_seconds)

	if pattern_time_elapsed >= next_pattern_time:
		var new_pattern = coin_patterns.pick_random().instantiate()
		new_pattern.global_position = %PatternOrigin.global_position
		%Collectibles.add_child(new_pattern)

		for child in new_pattern.get_children():
			var child_original_position = child.global_position
			new_pattern.remove_child(child)
			%Collectibles.add_child(child)
			child.global_position = child_original_position

		new_pattern.queue_free()

	if %Collectibles.get_child_count() == 0:
		next_pattern_time = randf_range(pattern_min_delay, pattern_max_delay)
	else:
		next_pattern_time = 9999.0
		pattern_time_elapsed = 0.0


	if music_time >= 76.62:
		%BGM.play(2.45)
		music_time = 2.45

func spawn_group(entity: PackedScene, start_position: Vector2, count: int, min_spacing: float, max_spacing: float) -> void:
	var spawn_position : Vector2 = start_position

	for i in range(count):
		var new_entity: Node2D = entity.instantiate()
		new_entity.global_position = spawn_position
		%Shootables.add_child(new_entity)
		spawn_position.x += randf_range(min_spacing, max_spacing)

func _on_bgm_finished() -> void:
	%BGM.play(2.5)
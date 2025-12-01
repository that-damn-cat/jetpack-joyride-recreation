extends Hitbox2D
class_name Bullet

enum TargetType {ENEMIES, PLAYER}

@export var target : TargetType = TargetType.ENEMIES

var angle_degrees : float = 90.0
var speed : float = 1000.0
var _direction := Vector2.RIGHT

func _ready() -> void:
	rotation_degrees = angle_degrees
	_direction = Vector2.RIGHT.rotated(deg_to_rad(angle_degrees))
	set_target(target)

func _process(delta: float) -> void:
	position += _direction * speed * delta

func _on_body_entered(_body: Node2D) -> void:
	queue_free()

func _on_floor_collision_body_entered(_body: Node2D) -> void:
	queue_free()

func set_target(target_type: TargetType):
	match target_type:
		TargetType.ENEMIES:
			set_collision_layer_value(Globals.CollisionLayers.PLAYER_BULLETS, true)
			set_collision_layer_value(Globals.CollisionLayers.HAZARDS, false)
			set_collision_mask_value(Globals.CollisionLayers.PLAYER, false)
			set_collision_mask_value(Globals.CollisionLayers.ENEMIES, true)
		TargetType.PLAYER:
			set_collision_layer_value(Globals.CollisionLayers.PLAYER_BULLETS, false)
			set_collision_layer_value(Globals.CollisionLayers.HAZARDS, true)
			set_collision_mask_value(Globals.CollisionLayers.PLAYER, true)
			set_collision_mask_value(Globals.CollisionLayers.ENEMIES, false)

	set_collision_mask_value(Globals.CollisionLayers.SHOOTABLES, true)
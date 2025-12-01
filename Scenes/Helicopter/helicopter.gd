extends Hurtbox2D

@export_category("Movement")
@export var speed: float = 120.0

@export_category("Shooting")
@export var bullet_scene: PackedScene
@export var bullet_speed: float = 1000.0
@export var cooldown_timer: Timer
@export var spawn_position: Marker2D

var target: CharacterBody2D
var bullet_angle: float
var bullet_container: Node2D
var can_shoot = false

func _ready() -> void:
	super()
	cooldown_timer.timeout.connect(_on_cooldown_timeout)
	cooldown_timer.start()
	target = get_tree().get_first_node_in_group("Player")
	bullet_container = get_tree().get_first_node_in_group("BulletContainer")

func _process(delta: float) -> void:
	bullet_angle = rad_to_deg(spawn_position.get_angle_to(target.global_position))
	if %ShapeCast2D.is_colliding():
		try_shoot()

	global_position.x -= speed * delta

func _on_cooldown_timeout() -> void:
	can_shoot = true

func try_shoot() -> void:
	if not can_shoot:
		return

	var new_bullet = bullet_scene.instantiate()
	if new_bullet is not Bullet:
		push_error("Fired scene not Bullet type!")
		return

	new_bullet = new_bullet as Bullet
	new_bullet.angle_degrees = bullet_angle
	new_bullet.global_position = spawn_position.global_position
	new_bullet.speed = bullet_speed
	new_bullet.target = Bullet.TargetType.PLAYER
	bullet_container.add_child(new_bullet)

	can_shoot = false


func _on_health_component_died() -> void:
	queue_free()

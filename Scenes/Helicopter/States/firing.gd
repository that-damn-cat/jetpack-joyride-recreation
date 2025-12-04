extends State

@export_category("Shooting")
@export var bullet_scene: PackedScene
@export var bullet_speed: float = 1000.0
@export var cooldown_timer: Timer
@export var spawn_position: Marker2D
@export var num_shots: int = 15
@export var aim_seconds: float = 1.5


var target: CharacterBody2D
var bullet_angle: float
var bullet_container: Node2D
var can_shoot = false
var cur_aim_time = 0.0

func enter() -> void:
	cooldown_timer.timeout.connect(_on_cooldown_timeout)
	cooldown_timer.start()
	target = get_tree().get_first_node_in_group("Player")
	bullet_container = get_tree().get_first_node_in_group("BulletContainer")
	bullet_angle = rad_to_deg(spawn_position.get_angle_to(target.global_position))
	%AimVisual.visible = true


func update(delta: float) -> void:
	cur_aim_time += delta

	if cur_aim_time < aim_seconds:
		var angle_error = abs(bullet_angle - rad_to_deg(spawn_position.get_angle_to(target.global_position))) / bullet_angle
		if angle_error > 0.01:
			bullet_angle = lerp(bullet_angle, rad_to_deg(spawn_position.get_angle_to(target.global_position)), clamp(aim_seconds - cur_aim_time, 0.05, 1.0))
	else:
		try_shoot()

	if num_shots <= 0:
		transition_to("leaving")

	var aim_target: Vector2 = Vector2.from_angle(deg_to_rad(bullet_angle)) * 3000.0
	%AimVisual.set_point_position(1, aim_target)


func exit() -> void:
	%AimVisual.visible = false


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

	num_shots -= 1
	can_shoot = false
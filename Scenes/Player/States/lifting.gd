@tool
extends State

@export_category("Jetpack")
@export var jetpack_force: Vector2 = Vector2(250.0, 350.0)	## Upward Force of Jetpack
@export var max_lift: float = 450.0							## Maximum Upward Velocity
@export var lift_ramp_speed: float = 2.0					## Rate of recovery if fired during fall/coast
@export var max_x_pos: float = 650.0						## Maximum x position value to drift to

@export_category("Bullets")
@export var bullet_scene: PackedScene
@export var spawn_position: Marker2D
@export var cooldown_timer: Timer
@export var bullet_speed: float = 1000.0
@export var speed_jitter: float = 250.0
@export var bullet_angle: float = 120.0
@export var angle_jitter: float = 10.0

var can_shoot: bool = true
var player: CharacterBody2D
var fall_state: State
var coast_state: State
var lift_ramp: float = 1.0

func _ready() -> void:
	if Engine.is_editor_hint():
		return

	# Get node references
	player = get_tree().get_first_node_in_group("Player") as CharacterBody2D
	fall_state = state_machine.get_state("falling")
	coast_state = state_machine.get_state("coasting")

	# Hook up shot cooldown
	cooldown_timer.timeout.connect(_on_cooldown_timeout)


func enter() -> void:
	# Default lift is at full power
	lift_ramp = 1.0
	player.velocity.x = 0.0

	# If we're recovering from fall/coast, start at 0% power
	if state_machine.previous_state in [fall_state, coast_state]:
		lift_ramp = 0.0

	%AnimationPlayer.play("jump_right")


func physics_update(_delta: float) -> void:
	# Lift force is the full jetpack force with a scaling factor (used when recovering)
	var lift_force: Vector2 = jetpack_force * lift_ramp

	player.velocity.y -= lift_force.y
	player.velocity.x = lift_force.x

	# Clamp the lift...
	if player.velocity.y <= -max_lift:
		player.velocity.y = -max_lift

	if player.global_position.x >= max_x_pos:
		player.velocity.x = 0.0

	# If lift ramp is happening, creep it upwards to full power
	if lift_ramp < 1.0:
		lift_ramp = min(lift_ramp + lift_ramp_speed * _delta, 1.0)

func update(_delta: float) -> void:
	# If the timer allows another bullet, fire it
	if can_shoot:
		shoot_bullet()
		can_shoot = false

	# Transition to coasting when jump released
	if Input.is_action_just_released("jump"):
		transitioned.emit(self, "coasting")

func shoot_bullet() -> void:
	var new_bullet := bullet_scene.instantiate()
	new_bullet.global_position = spawn_position.global_position
	new_bullet.angle_degrees = randf_range(bullet_angle - angle_jitter, bullet_angle + angle_jitter)
	new_bullet.speed = randf_range(bullet_speed - speed_jitter, bullet_speed + speed_jitter)
	spawn_position.add_child(new_bullet)
	%ShotSound.play_jitter()
	cooldown_timer.start()

func _on_cooldown_timeout() -> void:
	can_shoot = true

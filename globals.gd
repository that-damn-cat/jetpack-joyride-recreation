extends Node

## px/s
var run_speed: float = 350.0
var base_run_speed: float = 350.0

enum CollisionLayers {
	PLAYER = 1,
	BOUNDARIES,
	SHOOTABLES,
	PLAYER_BULLETS,
	HAZARDS,
	COLLECTABLES,
	ENEMIES
}
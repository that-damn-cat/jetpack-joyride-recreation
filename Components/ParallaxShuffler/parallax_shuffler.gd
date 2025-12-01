extends Parallax2D

@export var textures : Array[Texture2D]

var left_sprite : Sprite2D
var right_sprite : Sprite2D
var sprite_width : float

var last_offset_x : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	left_sprite = %LeftLayer
	right_sprite = %RightLayer

	left_sprite.texture = textures.pick_random()
	right_sprite.texture = textures.pick_random()

	sprite_width = get_sprite_width(left_sprite)
	repeat_size.x = sprite_width * repeat_times

	left_sprite.offset.x = -sprite_width / 2
	right_sprite.offset.x = sprite_width / 2

	last_offset_x = scroll_offset.x

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if (abs(last_offset_x) <= 2) and (scroll_offset.x > 0.75 * sprite_width):
		left_sprite.texture = right_sprite.texture
		right_sprite.texture = textures.pick_random()

	last_offset_x = scroll_offset.x



func get_sprite_width(sprite: Sprite2D) -> float:
	return sprite.texture.get_size().x * sprite.scale.x
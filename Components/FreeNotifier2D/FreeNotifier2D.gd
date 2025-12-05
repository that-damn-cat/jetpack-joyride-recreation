## A VisibleOnScreenNotifier2D which calls queue_free on its parent
## if it transitions from visible to not visible.
@icon("./sight-disabled.svg")
class_name FreeNotifier2D
extends VisibleOnScreenNotifier2D

var _was_visible: bool = false
@onready var _parent: Node = get_parent()

func _process(_delta: float) -> void:
	if not is_on_screen():
		if _was_visible:
			_parent.queue_free()
	else:
		if not _was_visible:
			_was_visible = true

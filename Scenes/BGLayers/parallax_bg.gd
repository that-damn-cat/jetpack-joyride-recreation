extends Node

func _process(_delta: float) -> void:
	%Floor.autoscroll.x      = -Globals.run_speed
	%Layer3.autoscroll.x     = 0.25 * %Floor.autoscroll.x
	%Layer2.autoscroll.x     = 0.5 * %Layer3.autoscroll.x
	%TrainLayer.autoscroll.x = %Layer2.autoscroll.x - 200.0
	%Layer1.autoscroll.x     = 0.5 * %Layer2.autoscroll.x

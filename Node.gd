extends Node

func _ready():
	if OS.get_name() == "HTML5":
		OS.set_window_maximized(true)
extends Node

func _ready():
	VisualServer.set_default_clear_color(Color(0, 0, 0))
	if OS.get_name() == "HTML5":
		OS.set_window_maximized(true)
tool

extends Node2D

export var color = Color(255,255,255) setget set_color
export var size = 5.0 setget set_size

func set_color(value):
	color = value
	update()
	
func set_size(value):
	size = value
	update()

func _draw():
	draw_rect(Rect2(-size, -size, size*2, size*2), color, false)
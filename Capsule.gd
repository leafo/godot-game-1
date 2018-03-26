tool
extends Node2D

export var radius = 2 setget set_radius
export var length = 5 setget set_length

export var color = Color(1,1,1)
export var border_color = Color()
export var border_width = 0

func _draw():
	if border_width > 0:
		for x in range(length):
			draw_circle(Vector2(x,0), radius + border_width, border_color)
		
	for x in range(length):
		draw_circle(Vector2(x,0), radius, color)
	
func set_radius(val):
	radius = val
	update()
	
func set_length(val):
	length = val
	update()
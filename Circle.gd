tool
extends Node2D

export var radius = 2 setget set_radius
export var color = Color(1,1,1)

export var border_color = Color()
export var border_width = 0

func _draw():
	if border_width > 0:
		draw_circle(Vector2(0,0), radius + border_width, border_color)
	draw_circle(Vector2(0,0), radius, color)
	
	
func set_radius(val):
	radius = val
	update()
tool
extends Node2D

export var radius = 2
export var color = Color(1,1,1)

func _draw():
	print("hello world")
	draw_circle(Vector2(0,0), radius, color)
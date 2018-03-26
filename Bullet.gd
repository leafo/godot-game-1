extends KinematicBody2D

var speed = 200
var direction = Vector2()
var velocity_adjust = Vector2()

func _physics_process(delta):
	if direction.length_squared() > 0:
		var c = move_and_collide((speed * direction + velocity_adjust) * delta)
		if c:
			
			queue_free()
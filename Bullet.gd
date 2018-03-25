extends KinematicBody2D

var speed = 200
var direction = Vector2()

func _physics_process(delta):
	if direction.length_squared() > 0:
		var c = move_and_collide(speed * direction * delta)
		if c:
			queue_free()
extends KinematicBody2D

var speed = 200
var direction = Vector2()
var velocity_adjust = Vector2()

var HitAnimation = preload("res://HitAnimation.tscn")

func _physics_process(delta):
	if direction.length_squared() > 0:
		var c = move_and_collide((speed * direction + velocity_adjust) * delta)
		if c:
			var hit = HitAnimation.instance()
			get_parent().add_child(hit)
			hit.emitting = true
			hit.position = c.position
			hit.rotation = c.normal.angle()
			hit.speed_scale = 2
			queue_free()
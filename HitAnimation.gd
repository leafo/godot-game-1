extends Particles2D

var CircleParticle = preload("res://CircleParticle.tscn")

func _ready():
	for i in range(2):
		var p = CircleParticle.instance()
		p.position = Vector2(rand_range(-1.5, 1.5), rand_range(-1.5, 1.5))
		p.get_node("Animation").playback_speed = rand_range(0.7,1.3)
		p.get_node("Circle").radius = rand_range(8,15)
		add_child(p)

func _on_Timer_timeout():
	queue_free()

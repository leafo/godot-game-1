extends Area2D

export(PackedScene) var warp_to
var activated = false

func _physics_process(delta):
#	if not warp_to:
#		return
	
	if activated:
		return
	
	for body in get_overlapping_bodies():
		print(body, body.get_groups())
		if "Player" in body.get_groups():
			activated = true
			print("Activate warp!")
	 


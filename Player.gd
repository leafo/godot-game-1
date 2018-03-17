extends KinematicBody2D


var SPEED = 200
var gun_direction = Vector2(1,0)
var direction = Vector2(1,0)
var just_shot = true

func _ready():
	pass
	
func merge_angles(from, to, p=0.5):
	var a = from.angle()
	var b = to.angle()
	
	if b - a > PI:
		a += 2 * PI
		
	if b - a < -PI:
		a -= 2 * PI
		
	var rad = a + (b - a) * p
	return Vector2(cos(rad), sin(rad))
	
func shoot():
	print("shoot")

func _physics_process(delta):
	var movement = Vector2()
	if Input.is_action_pressed("ui_left"):
		movement.x = -1
	elif Input.is_action_pressed("ui_right"):
		movement.x = 1
		
	if Input.is_action_pressed("ui_up"):
		movement.y = -1
	elif Input.is_action_pressed("ui_down"):
		movement.y = 1
		
	
	if Input.is_action_pressed("ui_accept"):
		if not just_shot:
			shoot()
		just_shot = true
	else:
		just_shot = false
	
	$Gun.set_rotation(gun_direction.angle())
	if movement.length_squared() != 0:
		direction = movement.normalized()
		# var gun_angle = gun_direction.angle()
		# gun_angle += delta
		# $Debug.text = "%s, %s" % [gun_direction.angle(), Vector2(cos(gun_angle), sin(gun_angle))]
		# gun_direction = Vector2(cos(gun_angle), sin(gun_angle))
		
		move_and_slide(direction * SPEED)
		
	gun_direction = merge_angles(gun_direction, direction, 0.1)

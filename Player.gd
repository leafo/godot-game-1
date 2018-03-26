extends KinematicBody2D

var Bullet = preload("res://Bullet.tscn")

var SPEED = 150
var gun_direction = Vector2(1,0)
var direction = Vector2(1,0)
var just_shot = false

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
	if just_shot:
		return
	
	just_shot = true
	var b = Bullet.instance()
	b.position = position
	b.direction = gun_direction
	get_parent().add_child(b)
	$ShootTimer.start()
	 
func deadzone_normalize(input, min_len=0.2, max_len=0.95):
	var l = input.length()
	if l > max_len:
		return input.normalized()
	
	if l < min_len:
		return Vector2()
		
	var sc = (l - min_len) / (max_len - min_len)
	return input.normalized() * sc

func _physics_process(delta):
	var movement = Vector2()
	var have_joystick = false
	
	var joy_movement = Vector2(Input.get_joy_axis(0, JOY_AXIS_0), Input.get_joy_axis(0, JOY_AXIS_1))
	if joy_movement.length_squared() > 0:
		joy_movement = deadzone_normalize(joy_movement)
		if joy_movement.length_squared() > 0:
			movement = joy_movement
			have_joystick = true
	
	if not have_joystick:
		if Input.is_action_pressed("ui_left"):
			movement.x = -1
		elif Input.is_action_pressed("ui_right"):
			movement.x = 1
			
		if Input.is_action_pressed("ui_up"):
			movement.y = -1
		elif Input.is_action_pressed("ui_down"):
			movement.y = 1
		
	
	if Input.is_action_just_pressed("ui_accept"):
		shoot()
	
	$Gun.set_rotation(gun_direction.angle())
	if movement.length_squared() != 0:
		direction = movement.normalized()
		# var gun_angle = gun_direction.angle()
		# gun_angle += delta
		# $Debug.text = "%s, %s" % [gun_direction.angle(), Vector2(cos(gun_angle), sin(gun_angle))]
		# gun_direction = Vector2(cos(gun_angle), sin(gun_angle))
		
		move_and_slide(direction * SPEED)
		
	gun_direction = merge_angles(gun_direction, direction, 0.1)


func _on_ShootTimer_timeout():
	just_shot = false

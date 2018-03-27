extends KinematicBody2D

var Bullet = preload("res://Bullet.tscn")

const SPEED = 120
const HIT_FORCE = 30

var gun_direction = Vector2(1,0)
var direction = Vector2(1,0)
var just_shot = false
var just_hit = false
var current_velocity = Vector2()
var push_force = Vector2()

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
	b.position = position + gun_direction * $Gun/Barrel.length
	b.direction = gun_direction
	b.velocity_adjust = current_velocity
	get_parent().add_child(b)
	$ShootTimer.start()
	$AnimationPlayer.play("Recoil")

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
		movement = direction * SPEED

	if push_force.length_squared() != 0:
		$Debug.text = str(push_force)
		# print("dampening push force", push_force, Vector2(), push_force.linear_interpolate(Vector2(), 0.5 * delta))
		movement += push_force
		push_force = push_force.linear_interpolate(Vector2(), delta / 0.06)

	if movement.length_squared() != 0:
		current_velocity = movement
		move_and_slide(movement)
		check_for_hits()

	gun_direction = merge_angles(gun_direction, direction, 0.1)

func check_for_hits():
	for i in range(get_slide_count()):
		var collision = get_slide_collision(i)
		var object = collision.collider

		if "Enemy" in object.get_groups():
			just_hit = true
			push_force = (position - object.position) * HIT_FORCE

func _on_ShootTimer_timeout():
	just_shot = false

func _on_HitTimer_timeout():
	just_hit = false

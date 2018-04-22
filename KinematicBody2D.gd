extends KinematicBody2D

const UP = Vector2(0,-1)
const GRAVITY = 20
const ACCELERATION = 50
const SPEED = 200
const MAXSPEED = 400
const JUMP_HEIGHT = -550
var can_jump = false

var res
var motion = Vector2()
var right = KEY_D
var left = KEY_A
var up = KEY_W
var down = KEY_S
var special
func _ready(player_1):
	res = get_viewport_rect().size
	set_physics_process(true)
	if player_1:
		right = "ui_right"
		left = "ui_left"
		up = "ui_up"
		down = "ui_down"
	else:
		right = "ui_d"
		left = "ui_a"
		up = "ui_w"
		down = "ui_s"
	pass
	
func _physics_process(delta):
	motion.y += GRAVITY
	motion.x = 0
	if Input.is_action_pressed(right):
#		motion.x += ACCELERATION
#		if motion.x > MAXSPEED:
		motion.x = SPEED
	if Input.is_action_pressed(left):
#		motion.x -= ACCELERATION
#		if -motion.x > MAXSPEED:
		motion.x = -SPEED
	#if is_on_floor():
	if Input.is_action_just_pressed(up) and (is_on_floor() or can_jump):
		motion.y = JUMP_HEIGHT
		$AnimatedSprite.play("up")
		can_jump = false
	
	
	position.x = clamp(position.x, 0, res.x)
	position.y = clamp(position.y, 0, res.y)
	if motion.length() >= 1:
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()

	if motion.y < 0:
		$AnimatedSprite.animation = "up"
	if motion.x != 0:
		$AnimatedSprite.animation = "move"
		$AnimatedSprite.flip_h = motion.x < 0
	if motion.y > 0:
		$AnimatedSprite.animation = "fall_down"
		
	if position.x == 0:
		position.x = res.x - 1
	if position.y == 0:
		position.y = res.y - 50
		can_jump = true
	if position.x == res.x:
		position.x = 1
	if position.y == res.y:
		position.y = 50
		can_jump = false
	
	motion = move_and_slide(motion, UP)
extends KinematicBody2D

const UP = Vector2(0,-1)
const GRAVITY = 20
const ACCELERATION = 50
const SPEED = 200
const MAXSPEED = 400
const JUMP_HEIGHT = -550

var res
var motion = Vector2()

func _ready():
	res = get_viewport_rect().size
	pass
	
func _physics_process(delta):
	motion.y += GRAVITY
	
	if Input.is_action_pressed("ui_right"):
#		motion.x += ACCELERATION
#		if motion.x > MAXSPEED:
		motion.x = SPEED
	if Input.is_action_pressed("ui_left"):
#		motion.x -= ACCELERATION
#		if -motion.x > MAXSPEED:
		motion.x = -SPEED
	#if is_on_floor():
	if Input.is_action_just_pressed("ui_up"):
		motion.y = JUMP_HEIGHT
		$AnimatedSprite.play("up")
	
	
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
	
	motion = move_and_slide(motion, UP)

#extends KinematicBody2D
#
## class member variables go here, for example:
## var a = 2
## var b = "textvar"
#
#var res
#var gravity
#export (int) var SPEED
#
#func _ready():
#	# Called every time the node is added to the scene.
#	# Initialization here
#	res = get_viewport_rect().size
#	gravity = res.y /19
#	start()
#
#
#func _process(delta):
##	# Called every frame. Delta is time since last frame.
##	# Update game logic here.
#	var velocity = Vector2()
#	var jump = false
#	if Input.is_action_pressed("ui_right"):
#		velocity.x += 1
#	if Input.is_action_pressed("ui_left"):
#		velocity.x -= 1
#	if Input.is_action_pressed("ui_up"):
#		velocity.y -= 1
#
##	while Input.is_action_pressed("ui_down"):
##		gravity += 90
##
#	if velocity.length() >= 1:
#		velocity = velocity.normalized() * SPEED
#		$AnimatedSprite.play()
#	else:
#		$AnimatedSprite.stop()
#
#	if velocity.y < 0:
#		$AnimatedSprite.animation = "up"
#	if velocity.x != 0:
#		$AnimatedSprite.animation = "move"
#		$AnimatedSprite.flip_h = velocity.x < 0
#	velocity.y += gravity
#
#
#	#position += (velocity * delta)
#	move_and_slide(velocity)
#	position.x = clamp(position.x, 0, res.x)
#	position.y = clamp(position.y, 0, res.y)
#
#
#func start():
#	position.x = res.x * 0.5
#	position.y = res.y * 0.5


extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var res
var gravity
export (int) var SPEED

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	res = get_viewport_rect().size
	gravity = res.y /7
	start()


func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
	var velocity = Vector2()
	var jump = false
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_just_pressed("ui_up"):
		velocity.y -= 1
		move_local_y(-(gravity*2))
	
#	while Input.is_action_pressed("ui_down"):
#		gravity += 90
#
	if velocity.length() >= 1:
		velocity = velocity.normalized() * SPEED
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	
	if velocity.y < 0:
		$AnimatedSprite.animation = "up"
	if velocity.x != 0:
		$AnimatedSprite.animation = "move"
		$AnimatedSprite.flip_h = velocity.x < 0
	velocity.y += gravity
		
	position += (velocity * delta)
	position.x = clamp(position.x, 0, res.x)
	position.y = clamp(position.y, 0, res.y)
	

func start():
	position.x = res.x * 0.5
	position.y = res.y * 0.5
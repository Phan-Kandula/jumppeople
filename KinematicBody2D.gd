extends KinematicBody2D

const UP = Vector2(0,-1)
const GRAVITY = 20
var grav = 1
const ACCELERATION = 50
const SPEED = 200
var speedo = 1
var pastspeedo = speedo
const MAXSPEED = 400
const JUMP_HEIGHT = -550
var can_jump = false
var time
var health

var res
var motion = Vector2()
var right = KEY_D
var left = KEY_A
var up = KEY_W
var down = KEY_S
var parry = KEY_SPACE
var special
var speedtime = -1000
var shieldtime = 1000
var invincibletime = 1000
var canFastFall
var canParry
var invincible
var is_dead

func _ready(player_1):
	time = 0
	health = 3
	canFastFall = false
	canParry = false
	invincible = false
	res = get_viewport_rect().size
	set_physics_process(true)
	#position.x = 1 *res.x / 3
	#position.y = 2 *res.y / 3

	if player_1:
		right = "ui_right"
		left = "ui_left"
		up = "ui_up"
		down = "ui_down"
		parry = "ui_p"
	else:
		right = "ui_d"
		left = "ui_a"
		up = "ui_w"
		down = "ui_s"
		parry = "ui_space"
	pass
	
#get_tree().get_root().get_node("scene_main_node/node_wanted")	

func _physics_process(delta):
	time+=delta
	motion.x = 0
	if Input.is_action_pressed(right):
#		motion.x += ACCELERATION
#		if motion.x > MAXSPEED:
		motion.x = SPEED * speedo
	if Input.is_action_pressed(left):
#		motion.x -= ACCELERATION
#		if -motion.x > MAXSPEED:
		motion.x = -SPEED * speedo
	#if is_on_floor():
	if Input.is_action_just_pressed(up) and (is_on_floor() or can_jump):
		motion.y = JUMP_HEIGHT
		$AnimatedSprite.play("up")
		can_jump = false
	if canFastFall and Input.is_action_just_pressed(down):
		grav = 50
		pass
	motion.y += GRAVITY * grav
	grav = 1
	if canParry and Input.is_action_just_pressed(parry):
		#parry	
		pass
		
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
	
	if (speedtime + 5.0) >= time:
		speedo = 4
	else:
		speedo = pastspeedo
	if (shieldtime + 30.0) <= time:
		health -= 1
		shieldtime = 10000
		print(health)
	if(invincibletime + 2) <= time:
		invincible = false
		
		
	var collision_info = move_and_collide(SPEED*delta*motion.normalized())
	if collision_info:
			var bodyHit = (collision_info.collider)
			if bodyHit.name == "speed":
				bodyHit.queue_free()
				if(SPEED * speedo <= MAXSPEED):
					speedo += .25
			elif bodyHit.name == "speedX":
				pastspeedo = speedo
				speedtime = time
				bodyHit.queue_free()
			elif bodyHit.name == "shield":
				shieldtime = time
				health+=1
				print(health)
				bodyHit.queue_free()
			elif bodyHit.name == "invincibility":
				bodyHit.queue_free()
			elif bodyHit.name == "fallspeed":
				canFastFall = true
				bodyHit.queue_free()
			elif bodyHit.name == "parry":
				canParry = true
				bodyHit.queue_free()
			elif bodyHit.name == "freeze":
				bodyHit.queue_free()
			elif bodyHit.name == "KinematicBody2D":
				if(!invincible):
					if(bodyHit.position.y > position.y):
						health -= 1
					if(bodyHit.position.y < position.y):
						bodyHit.health -= 1
					invincible = true
					invincibletime = time
				print("Human Health ", health)
				print("Zombie Health ", bodyHit.health)
				dead()
			elif bodyHit.name == "zombie":
				if(!invincible):
					if(bodyHit.position.y > position.y):
						health -= 1
					if(bodyHit.position.y < position.y):
						bodyHit.health -= 1
					invincible = true
					invincibletime = time
				print("Zombie ", health)
				print("Human Health ", bodyHit.health)
				dead()
	